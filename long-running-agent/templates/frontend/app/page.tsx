'use client';

import { HomeHero, FeaturesList, useHome } from '@/features/home';

function HomeContent() {
  const { data, loading, error } = useHome();

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[50vh]">
        <div className="text-lg text-gray-600">Loading...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-[50vh]">
        <div className="text-lg text-red-600">Error: {error.message}</div>
      </div>
    );
  }

  if (!data) {
    return null;
  }

  return (
    <>
      <HomeHero data={data} />
      <FeaturesList features={data.features} />
    </>
  );
}

export default function HomePage() {
  return <HomeContent />;
}
