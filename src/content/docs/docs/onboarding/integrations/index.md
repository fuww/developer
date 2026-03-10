---
title: Integrations (Feed & Scraper)
description: "How to integrate your ATS or career page with FashionUnited using job feeds or scrapers."
---

An ATS (Applicant Tracking System) is a system which clients use to track the status of candidates who apply via their own career page. Posting positions via an ATS system gives you the ability to manage candidates that apply for positions — including when the job is posted on FashionUnited, since we will most likely use an external application link which leads to your website and application form.

These systems give you the ability to post open positions on your own career page and on external websites such as Indeed, LinkedIn and FashionUnited.

When you see "FashionUnited" as an external page you can select in your ATS system, we either already have a running connection, or are able to set it up. When in doubt, reach out to [jobs@fashionunited.com](mailto:jobs@fashionunited.com) and the Customer Service team will check.

## Job Feed

To set up a feed we need a so-called XML URL. Share this with the Customer Service team via [jobs@fashionunited.com](mailto:jobs@fashionunited.com).

The URL should contain all the jobs you want published. The link can also be called RSS, JSON or API link/URL.

To keep things simple, we also accept existing feeds you might have created for other job boards, like:

- LinkedIn
- Indeed
- Trovit
- Jobrapido
- Or others

As long as all the jobs you want posted on the FashionUnited platform are in your JSON or XML feed, we make sure they are shown on the FashionUnited platform.

### Mandatory fields

The following information must be present in the feed:

| Field | Description |
|---|---|
| Unique job ID | External ID for the job in your system |
| Job title | Only the title — no location, company name, etc. |
| Job category | One of: "Design & Creative", "Internships", "Other", "Product & Supply Chain", "Retail Management & In-store", "Sales & Marketing" |
| Teaser text | Short text displayed in the job list |
| Vacancy text | Full job description |
| Location | City (an address can also be sent) |
| Country | Country of the job |
| Company name | Name of the employer |
| Apply URL | Unique per job ID |

### Example XML feed

For a complete XML feed example with all supported fields, see [Jobs Feed (JSON/XML)](/docs/jobs/).

### Feed refresh

The feed refreshes once per day during the week and syncs the content with what is displayed on the FashionUnited job board.

## Job Scraper

If you have jobs on your own website but do not have an ATS system, or your ATS provider charges a setup fee to add FashionUnited, we can build a scraper tool.

The scraper "copies" jobs that are currently live on your career page. Jobs that are no longer there when the scraper checks will go offline on our job board. A scraper basically mirrors the jobs on your page to our page.

### Setup

Share the link to your career page with the Customer Service team via [jobs@fashionunited.com](mailto:jobs@fashionunited.com).

### Important notes

- Not all career pages are set up in a way that a scraper tool will work
- If you make any changes to the structure of your website/career page, the scraper may stop working
- The scraper refreshes once per day during the week
