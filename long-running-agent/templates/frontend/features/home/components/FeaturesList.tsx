interface FeaturesListProps {
  features: string[];
}

export function FeaturesList({ features }: FeaturesListProps) {
  return (
    <section className="py-16">
      <h2 className="text-3xl font-bold text-center mb-12 text-gray-900 dark:text-white">
        Features
      </h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 max-w-6xl mx-auto">
        {features.map((feature, index) => (
          <div
            key={index}
            className="p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md hover:shadow-lg transition-shadow"
          >
            <div className="w-12 h-12 bg-primary-100 dark:bg-primary-900 rounded-lg flex items-center justify-center mb-4">
              <span className="text-primary-600 dark:text-primary-400 font-bold">
                {index + 1}
              </span>
            </div>
            <p className="text-gray-700 dark:text-gray-300">{feature}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
