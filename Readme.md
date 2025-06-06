# ipragnes

## Description

This is the project to collect the ipranges from the cloud providers and specific services.
This project also saves the ipranges with CIDR format in the txt file.

## Installation

```bash
git clone https://www.github.com/Neidn/ipragnes
```

## Build Results

![Result](https://github.com/Neidn/ipranges/actions/workflows/update_amazon.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_cloudflare.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_digitalocean.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_vultr.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_scaleway.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_oracle.yml/badge.svg)
![Result](https://github.com/Neidn/ipranges/actions/workflows/update_ovh.yml/badge.svg)

## Data Sources

* Amazon Web Services (AWS) - https://ip-ranges.amazonaws.com/ip-ranges.json
* Cloudflare
    * IPv4 - https://www.cloudflare.com/ips-v4
    * IPv6 - https://www.cloudflare.com/ips-v6
* DigitalOcean (DO) - https://digitalocean.com/geo/google.csv
* Vultr - https://geofeed.constant.com/?text
* Scaleway - https://www.scaleway.com/en/docs/console/account/reference-content/scaleway-network-information/
* Oracle Cloud Infrastructure (OCI) - https://docs.oracle.com/en-us/iaas/tools/public_ip_ranges.json
* Google Cloud Platform (GCP) - https://www.gstatic.com/ipranges/cloud.json
* OVH Cloud - https://rest.db.ripe.net/search?inverse-attribute=origin&source=ripe&query-string=AS16276

## To Do

* Add more cloud providers
    * Microsoft Azure
    * IBM Cloud
    * Alibaba Cloud
    * Tencent Cloud
    * Baidu Cloud
    * Huawei Cloud
