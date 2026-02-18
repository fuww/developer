import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

export const prerender = false;

export const GET: APIRoute = async ({ params }) => {
  const slug = params.slug || '';
  const docs = await getCollection('docs');
  const doc = docs.find(entry => entry.slug === slug);

  if (!doc) {
    return new Response('Not found', { status: 404 });
  }

  return new Response(doc.body, {
    status: 200,
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
    },
  });
};
