# Snack Vote (Supabase version)

Students vote on one question four ways (first past the post, ranked choice, 15-point scored ballot, and approval voting) and see live results. No student accounts needed.

Files: `index.html` (the page), `setup.sql` (creates the vote table), `README-supabase.md` (this file).

You'll set up two free things once: **Supabase** (stores the votes; you sign in with GitHub, no Google account needed) and **GitHub Pages** (hosts the page).

## Part 1: GitHub (the website)

1. Go to https://github.com, click **Sign up**, and create an account. Verify your email with the code GitHub sends.
2. Click the **+** at the top right, then **New repository**. Name it `snack-vote`, choose **Public**, and click **Create repository**.
3. Click **uploading an existing file**, drag in `index.html`, `setup.sql`, and `README-supabase.md`, then click **Commit changes**. (You'll edit `index.html` in Part 3.)
4. Go to **Settings, then Pages**. Under **Build and deployment**, set Source to **Deploy from a branch**, Branch to **main** and **/ (root)**, then click **Save**.
5. After a minute or two, refresh. Your site address appears at the top, like `https://YOUR-USERNAME.github.io/snack-vote/`.

## Part 2: Supabase (the vote storage)

1. Go to https://supabase.com and click **Start your project**. Choose **Continue with GitHub** and approve it.
2. If asked to create an organization, name it anything, choose **Personal** and the **Free** plan.
3. Click **New project**. Name it `snack-vote`, click **Generate a password** (you won't need it again), pick the region closest to you, and click **Create new project**. Wait a couple of minutes while it sets up.
4. In the left menu, click **SQL Editor**, then **New query**. Open `setup.sql`, copy everything, paste it in, and click **Run**. You should see "Success. No rows returned." (If you ran an earlier version of `setup.sql`, run this new one too. It is safe to run again and adds the approval voting column.)
5. Click the **gear icon (Project Settings)**, then **API** (it may be called **API Keys** or **Data API**). Copy two things: the **Project URL** (starts with `https://` and ends in `.supabase.co`) and the **anon public** key (a long string; newer projects may call it the **publishable** key).

## Part 3: Connect them

1. On GitHub, open your repository, click `index.html`, then the **pencil icon** (Edit this file).
2. Near the top of the script, find the block marked `PASTE YOUR SUPABASE SETTINGS HERE`. Replace the text inside the quotation marks on the two lines with the Project URL and the anon key. Keep the quotation marks and semicolons.
3. Click **Commit changes**, then **Commit changes** again. Wait a minute, then reload your site.

The anon key is meant to be public, so it's fine that it's visible in the page. The rules in `setup.sql` are what limit what visitors can do.

## The Reset all votes button

The **Reset all votes** button at the top right deletes every vote for the current question after you confirm in a pop-up box. Students who already voted can vote again within a few seconds. It works after you run `setup.sql` (Part 2, step 4). There is no passcode, so anyone who has the link can use it. Share the link only with your class.

## Test before class

1. Open your site on a laptop, vote in all three sections, and click **Submit my votes**. The page should jump to the results, and the first tab should say **Voted ✓**.
2. Open the same address on your phone (use **Show QR code to join** on the laptop to scan it), vote there too, and watch the laptop's results update within a few seconds.
3. Try to vote again on the same device. It should stay locked.

## Running a new vote

Edit `index.html` on GitHub and change `QUESTION` and `OPTIONS`, and change `ROUND` to something new like `"round2"`. Everyone can then vote again, and each round's results stay separate. To delete old votes, use **Table Editor** in Supabase, open `votes`, select rows, and delete.

## One vote per browser (and its limits)

- Each browser gets a random voter ID. After submitting, the ballot locks on that browser.
- The database allows only one vote per voter ID per round and blocks edits or deletes from the page.
- A student can bypass this by clearing site data, using a private window, or switching devices. That's fine for a supervised classroom activity but not for anything that needs real security.
- Votes are anonymous: no names, emails, or accounts are collected. Anyone with the link can read results and vote, so share it only with your class. Ballots with more than 15 scored points are ignored in the tally.

## Troubleshooting

- **"Setup needed" at the top of the page:** the two Supabase values in `index.html` are still placeholders.
- **"Couldn't load live results":** the SQL in step 4 of Part 2 didn't run successfully, or the URL or key has a typo.
- **Can't submit a vote:** same cause as above, or you already voted from this browser in this round.
- **Page doesn't change after editing:** wait a minute and do a hard refresh.
- **School network blocks it:** the page loads from `github.io` and talks to `supabase.co`. Ask IT to allow both.
