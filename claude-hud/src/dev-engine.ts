import * as fs from 'node:fs';
import * as path from 'node:path';
import type { DevEngineData } from './types.js';

function readJSON(filePath: string): unknown {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

function readLastLines(filePath: string, n = 1): string[] {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const lines = raw.trim().split('\n').filter(Boolean);
    return lines.slice(-n);
  } catch {
    return [];
  }
}

interface ManifestRequirement {
  id?: string;
  dir?: string;
  name?: string;
  description?: string;
  status?: string;
}

interface Manifest {
  requirements?: ManifestRequirement[];
}

interface Feature {
  id?: string;
  name?: string;
  passes?: boolean;
  blocked?: boolean;
}

interface FeatureList {
  features?: Feature[];
}

/**
 * Read dev-engine project data from the working directory.
 * Returns null if no .dev-enegine directory is found.
 */
export function getDevEngineData(cwd?: string): DevEngineData | null {
  try {
    const dir = cwd || process.cwd();
    const manifestPath = path.join(dir, '.dev-enegine/requirements/manifest.json');
    const manifest = readJSON(manifestPath) as Manifest | null;

    if (!manifest?.requirements?.length) {
      return null;
    }

    const reqs = manifest.requirements;
    const developing = reqs.find((r) => r.status === 'developing');
    const planning = reqs.find((r) => r.status === 'planning');
    const target = developing || planning || reqs[reqs.length - 1];

    if (!target) {
      return null;
    }

    const reqId = target.id || target.dir;
    let requirementName = target.name || target.description || reqId;
    if (!requirementName) {
      return null;
    }
    if (requirementName.length > 20) {
      requirementName = requirementName.slice(0, 19) + '…';
    }

    let featureTotal = 0;
    let featureDone = 0;
    let currentFeatureName: string | null = null;

    const featurePath = reqId
      ? path.join(dir, `.dev-enegine/requirements/${reqId}/feature_list.json`)
      : null;
    const featureList = featurePath ? readJSON(featurePath) as FeatureList | null : null;

    if (featureList?.features && Array.isArray(featureList.features)) {
      const features = featureList.features;
      featureTotal = features.length;
      featureDone = features.filter((f) => f.passes === true).length;

      const inProgress = features.find((f) => !f.passes && !f.blocked);
      if (inProgress) {
        currentFeatureName = inProgress.name || inProgress.id || null;
        if (currentFeatureName && currentFeatureName.length > 24) {
          currentFeatureName = currentFeatureName.slice(0, 23) + '…';
        }
      } else if (featureDone === featureTotal && featureTotal > 0) {
        currentFeatureName = '✓ all done';
      }
    }

    const progressLogPath = path.join(dir, '.dev-enegine/claude-progress.txt');
    const recentLogs = readLastLines(progressLogPath, 1);
    const lastLog = recentLogs[0]
      ? recentLogs[0].replace(/^\[.*?\]\s*/, '')
      : null;

    return {
      requirementName,
      requirementStatus: target.status || null,
      currentFeatureName,
      featureTotal,
      featureDone,
      lastLog,
    };
  } catch {
    return null;
  }
}
