export interface HomeData {
  title: string;
  message: string;
  features: string[];
  version: string;
}

export async function getHome(locale = 'en'): Promise<HomeData> {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080';
  try {
    const response = await fetch(`${apiUrl}/project.v1.HomeService/GetHome`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ locale }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data.msg;
  } catch (error) {
    // Return mock data if API is not available
    return {
      title: 'Welcome to the Project',
      message: 'This is the home page of our application',
      features: [
        'Feature 1: Clean Architecture',
        'Feature 2: TypeScript Support',
        'Feature 3: Modern UI',
      ],
      version: '1.0.0',
    };
  }
}
