# AWS VPC Lab: Security Groups vs Network ACLs

A hands-on AWS networking lab. You build a custom VPC, launch two EC2 instances with different security groups, then change security group and NACL rules and watch what traffic gets through.

Created by **Rutuja Naik**.

## What you will learn

- How to create a custom VPC with public subnets and an Internet Gateway
- How security groups (instance level, stateful) differ from network ACLs (subnet level, stateless)
- How to restrict access to a single IP and to another security group
- Why a NACL deny rule needs a lower rule number than the default allow rule

## What is in this repository

```
aws-vpc-lab/
├── index.html                  Project web page (open in any browser)
├── css/
│   └── style.css               Styles for the web page
├── docs/
│   └── AWS_VPC_Lab_Guide.pdf   Full step-by-step lab documentation
├── scripts/
│   └── user-data.sh            EC2 user data script (installs Apache)
├── .gitignore
├── LICENSE
└── README.md
```

## Prerequisites

- An AWS account (Free Tier is enough)
- A region selected in the AWS Console
- A key pair, or use EC2 Instance Connect
- Do not create a NAT gateway for this lab; it is not needed and it costs money

## Lab summary

| Resource | Name | Purpose |
|---|---|---|
| VPC | `lab1-custom` | Isolated network with public subnets and an Internet Gateway |
| Security group | `SGA` | Allows HTTP (80) and SSH (22) from anywhere |
| Security group | `SGB` | Allows HTTP, SSH, and ICMP from SGA |
| EC2 instance | `Instance-A` | Apache web server, uses SGA |
| EC2 instance | `Instance-B` | Apache web server, uses SGB |

### Steps

1. **Create the VPC.** Use *VPC and more*, name it `lab1-custom`, choose no NAT gateway, then enable auto-assign public IPv4 on the public subnets.
2. **Create SGA and SGB.** Create SGA first, because SGB refers to it for ICMP.
3. **Launch the instances.** Amazon Linux, t2.micro, public subnet, public IP enabled. Paste [`scripts/user-data.sh`](scripts/user-data.sh) into User data. Use SGA for Instance-A and SGB for Instance-B.
4. **Test the baseline.** Browser to the public IP, EC2 Instance Connect, ping A to B using the private IP, and curl from B to A.
5. **Change the rules and re-test.**
   - **Change 1:** limit SGA HTTP to `YOUR_IP/32`.
   - **Change 2:** add a NACL inbound **deny** rule numbered **90** for your IP.
   - **Change 3:** limit SGB HTTP to SGA as the source, and test using Instance-B's **private** IP.

The full guide, with rule tables, expected results, and troubleshooting, is in [`docs/AWS_VPC_Lab_Guide.pdf`](docs/AWS_VPC_Lab_Guide.pdf).

## Key lessons

- NACL rules are evaluated from the lowest number up, and the first match wins. The default allow rule is 100, so a deny rule must be lower than 100.
- A security group rule that references another security group only matches the private addresses of that group. Test with the private IP.
- Security groups only allow traffic. NACLs can allow or deny, and they are stateless.

## View the web page

Open `index.html` in a browser. No build step or dependencies are needed (fonts load from Google Fonts when online).

### Publish it with GitHub Pages

1. Push this repository to GitHub (commands below).
2. Open the repository on GitHub, then **Settings > Pages**.
3. Under **Build and deployment**, set **Source** to **Deploy from a branch**.
4. Choose the `main` branch and the `/ (root)` folder, then **Save**.
5. After a minute, your page is live at `https://YOUR-USERNAME.github.io/aws-vpc-lab/`.

## Upload this project to GitHub

Create an empty repository named `aws-vpc-lab` on GitHub (no README, no license), then run this in the project folder:

```bash
git init
git add .
git commit -m "Add AWS VPC lab guide and web page"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/aws-vpc-lab.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

## Clean up

To avoid charges, terminate both instances, delete the `lab1-custom` VPC, then delete SGA and SGB.

## License

Released under the [MIT License](LICENSE).

## Author

Created by **Rutuja Naik**.
