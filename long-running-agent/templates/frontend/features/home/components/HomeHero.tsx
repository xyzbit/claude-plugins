import { HomeData } from '../api';

interface HomeHeroProps {
  data: HomeData;
}

export function HomeHero({ data }: HomeHeroProps) {
  return (
    <section className="py-20 text-center">
      <h1 className="text-5xl font-bold mb-4 text-gray-900 dark:text-white">
        {data.title}
      </h1>
      <p className="text-xl text-gray-600 dark:text-gray-300 mb-8 max-w-2xl mx-auto">
        {data.message}
      </p>
      <div className="inline-block px-4 py-2 bg-primary-100 text-primary-800 rounded-full">
        Version: {data.version}
      </div>
    </section>
  );
}
