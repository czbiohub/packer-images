# packer-images

Repository for Biohub packer images

# Images for general use

All AMIs are in the US-West-2 (Oregon) region.

| Image Name | latest AMI ID | Description |
| --- | --- | --- |
| `czbiohub-ubuntu16-[DATE]` | ami-02ed337a | Updated Ubuntu with `make`, `g++`, and `awscli` |
| `czbiohub-anaconda-[VERSION]-[DATE]` | ami-xxxxxxx | Ubuntu16 + Anaconda 5.0.1 | 
| `czbiohub-bowtie2-[DATA]` | ami-xxxxxxx | Anaconda + Bowtie2 |


## Workflow

If you're having trouble with any of these steps, ask in #eng-support

0. clone the repo with `git clone https://github.com/czbiohub/packer-images.git`
0. create a branch
    * In the command line, you can type `git checkout -b [branch name]`
0. copy an existing image file, e.g. `anaconda-example.json`
0. change "ami_name" and "ami_description" to something descriptive
    * For personal images, use the convention [USERNAME]-ami-name-[DATE]. See `anaconda-example.json` for a template.
    * Shared images should start with `czbiohub`.
0. update the provisioner, build, run your instance, repeat until you're satisfied
0. push your branch and send a pull request
    * To push a branch, use `git push --set-upstream origin [your branch name]`
    * The branch should appear here on the [repository website](https://github.com/czbiohub/packer-images) and there will be a link to make a new Pull Request.
    * Describe your changes in the text box and (optionally) request reviewers.

## Why this repo?

If you put your templates in this repo, the data-science and/CZI eng teams can help to do things like make updates, enforce best practices, etc.

## How to use the images


You can run the image with `aegea launch`, e.g.

```
➜  ~ aegea launch --instance-type t2.micro --duration-hours 2  --ami ami-70ee4b0a olgabot-anaconda                   
Identity added: /Users/olgabot/.ssh/aegea.launch.olgabot.Olgas-MacBook-Pro.pem (/Users/olgabot/.ssh/aegea.launch.olgabot.Olgas-MacBook-Pro.pem)
INFO:aegea:Launch spec user data is 1883 bytes long
INFO:aegea:Launching <aegea.util.aws.spot.SpotFleetBuilder object at 0x10acfe940: {'cores': 1, 'dry_run': False, 'gpus_per_instance': 0, 'iam_fleet_role': iam.Role(name='SpotFleet'), ...}>
INFO:aegea:Launched ec2.Instance(id='i-046b932d342d9960a') in ec2.Subnet(id='subnet-9cfc1fd4')
{
  "instance_id": "i-046b932d342d9960a"
}
```

Where `ami-70ee4b0a` is the Amazon machine image ID and `olgabot-anaconda` is
the name of the launched image.  `t2.micro` indicates the type of machine which
means how powerful it is, i.e. how many CPUs, how much storage, memory, etc, and
a helpful website for looking up AWS EC2 instances is http://www.ec2instances.info/

You can then log on to your instance with `aegea ssh`, so continuing our example, that would be:

```
➜  ~ aegea ssh ubuntu@olgabot-anaconda
zsh: correct 'ssh' to '.ssh' [nyae]? n
Warning: Permanently added the RSA host key for IP address '34.229.183.249' to the list of known hosts.
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-1038-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@olgabot-anaconda:~$
```
