import { test, expect } from '@playwright/test';

test.describe('Markdown API endpoint ([...slug].md.ts)', () => {
  test('GET /docs/introduction.md returns 200 with text/plain content type', async ({ request }) => {
    const response = await request.get('/docs/introduction.md');
    expect(response.status()).toBe(200);
    expect(response.headers()['content-type']).toContain('text/plain');
  });

  test('GET /docs/introduction.md response body contains markdown content', async ({ request }) => {
    const response = await request.get('/docs/introduction.md');
    const body = await response.text();
    expect(body.length).toBeGreaterThan(0);
    expect(body).toMatch(/#|\w+/);
  });

  test('GET /nonexistent-page.md returns 404', async ({ request }) => {
    const response = await request.get('/nonexistent-page.md');
    expect(response.status()).toBe(404);
  });

  test('GET /docs/marketplace/graphql-api.md returns 200', async ({ request }) => {
    const response = await request.get('/docs/marketplace/graphql-api.md');
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body.length).toBeGreaterThan(0);
  });
});
