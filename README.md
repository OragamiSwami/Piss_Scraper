# Piss_Scraper

Pulls a list of links from the active list.

Must have curl installed.

Modify unreal_dir to the directory hosting unrealircd

add include to main configuration for the value of $file #Note that we have removed autoconnect from all links, please manuall add desired autoconnect link blocks to the main config to over-ride those in the scraped output

execute the script

script will preform configtest and rehash only if successful

Can be automated with crontab entry such as every 5 minutes Ref(crontab.guru/#*/5 * * * *) with:

*/5 * * * * $pathTo/pull_piss_links.sh
