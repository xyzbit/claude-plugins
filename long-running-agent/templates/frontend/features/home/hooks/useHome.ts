'use client';

import { useState, useEffect } from 'react';
import { getHome, HomeData } from '../api';

export function useHome() {
  const [data, setData] = useState<HomeData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    async function fetchHome() {
      try {
        const homeData = await getHome();
        setData(homeData);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Failed to fetch home data'));
      } finally {
        setLoading(false);
      }
    }

    fetchHome();
  }, []);

  return { data, loading, error };
}
