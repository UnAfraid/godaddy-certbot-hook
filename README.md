# godaddy.com certbot hook
A shell script to be used for auth hook when issuing a certificate through certbot (https://letsencrypt.org) for domains managed by godaddy.com (https://godaddy.com)

This script was created with the intention of issuing wildcard domain certificates. For example: *.example.org
It is made to avoid creating multiple certificates for every sub-domain you own.
Nevertheless it should work perfectly fine for non-wildcard domains as well.

### Be warned:
This script will automatically change your DNS settings. While it manages to revert back everything to how it was, there is absolutely no guarantee that everything will run flawless.
It is a task that could fail at any time, so it's suggested to confirm after running this script that everything is how it should be.

Copy .env-dist as .env and fill the required data inside

# Issue an actual and valid certificate for your domain:
(if you want to test-run before the real action, read the next paragraph below)

To create a valid certificate, you need to run the following command:

Clone the repository if you haven't already

```sh
git clone https://github.com/UnAfraid/godaddy-certbot-hook
cd godaddy-certbot-hook

# Copy the default .env-dist as .env
cp .env-dist .env

# Edit it using your favorite editor vi/vim/nano/mcedit/...
nano .env
```

Now issue a wildcard certificate
```sh
./certbot-dns.sh *.yourdomain.com
```
