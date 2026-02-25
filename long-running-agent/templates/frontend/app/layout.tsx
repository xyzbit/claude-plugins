import type { Metadata } from 'next';
import '@/styles/globals.css';

export const metadata: Metadata = {
  title: 'Project Name',
  description: 'A modern fullstack application built with Clean Architecture',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-50 dark:bg-gray-900">
        <header className="bg-white dark:bg-gray-800 shadow-sm">
          <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between h-16 items-center">
              <div className="flex-shrink-0">
                <span className="text-xl font-bold text-primary-600">
                  Project
                </span>
              </div>
              <div className="hidden md:flex space-x-8">
                <a href="#" className="text-gray-700 dark:text-gray-300 hover:text-primary-600">
                  Home
                </a>
                <a href="#" className="text-gray-700 dark:text-gray-300 hover:text-primary-600">
                  About
                </a>
                <a href="#" className="text-gray-700 dark:text-gray-300 hover:text-primary-600">
                  Contact
                </a>
              </div>
            </div>
          </nav>
        </header>
        <main>{children}</main>
        <footer className="bg-white dark:bg-gray-800 py-8 mt-20">
          <div className="max-w-7xl mx-auto px-4 text-center text-gray-600 dark:text-gray-400">
            <p>&copy; 2024 Project Name. All rights reserved.</p>
          </div>
        </footer>
      </body>
    </html>
  );
}
