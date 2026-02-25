/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    serverComponentsExternalPackages: ['@connectrpc/connect'],
  },
}

module.exports = nextConfig
