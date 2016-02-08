---
layout: post
title: 'Microsoft Band - Review'
categories: coding cpp
---

Microsoft Band is a wearable device well designed for fitness activities, but
with a few rough edges.


# What it is

Microsoft Band is a wearable device. You wear it on the wrist. It has a touch
sensitive display and it is packed with sensors like: accelerometer/gyrometer,
optical heart rate monitor, GPS, etc.

Here are the two versions side by side. Version 2 has an updated design with a
curved screen and even more sensors.

![Version 1](/assets/2016-01-27-ms-band-review/band1.jpeg)
![Version 2](/assets/2016-01-27-ms-band-review/band2.jpeg)

It has applications that are called tiles. E.g. there is a tile for running. You
select the tile on the display, press a button, and the device records the
number of steps, the heart rate, and the route.

The tiles fall into several categories:

- Clock: basic clock, alarm, timer, stopwatch
- Fitness: in addition to the running, there are tiles for cycling, exercise, guided
workouts, golf.
- Sleep monitoring
- Notifications: calendar, mail, phone call ID, SMS, Facebook, Twitter etc.

You need to connect it to a phone so that data gets uploaded to the cloud. You
can see the data through you browser.

# First impressions odyssey

So my brother asks: "Can I have a package delivered to you in the UK?". Sure.
"You see, I want to buy myself a Microsoft Band 2 device, and they only sell it
in English speaking countries". Fine. My brother is into sports: running (half
marathons), squash, cycling. He already had the first version of the device. He
likes his new toy. I spend a whole night looking to buy similar devices. I decide
against, they are too expensive. My brother offers me his old toy. So here's
how I ended up using a Microsoft Band for free.

So I have a run with the band on and then I try to sync the device. And here
the saga starts:

- The Mac sync application did not want to login.
- The PC sync application logs in, but asks to plug in the device even if it's
  plugged in. Rebooting does not help.
- I hoped that resetting the device to factory defaults might help. It did not,
  and now it only displays a text asking to be connected to a phone.
- I only have a phone phone.
- Never mind, I'll run a Windows Phone emulator. Well, that does not actually
  support Bluetooth.
- Never mind, I'll run Android x86 on a virtual machine
- Well, it can't partition the disk, so I first boot Ubuntu to partition the
  disk, then install Android x86
- The Microsoft Health app does not want to install on the virtual machine from
  the Google Play store
- But I can dowload the apk file, and now it runs ... sideways. So I have move
  the finger up and down the trackpad in order to move the cursor left and
  right.
- And I can login, and see the device on bluetooth, but does not want to
  connect to the device
- So I try an older version of Android, same
- So I try back the newer Android version, it still does not connect.
- But it connects to the band after a reboot.
- But I stopped it after 20 mins of 'Just a few moments. Syncing ...'
- Then it did not want to connect to the band again. Rebooting does not help.
- Then I installed Android x86 on a USB and booted the PC from the USB.
  Installed the apk, rebooted, connected, synced.
- And I finally got to the point where I can use the band again.

I'm not alone in experiencing issues, as per the review comments on the sync
application for Mac ("What's New in Version 1.3.20104: Bug Fixes").

![Reviews](/assets/2016-01-27-ms-band-review/reviews.png)

I can now also login into the Mac sync application. And the Windows one also
detects now the device.

However from time to time things don't work though:

- On Mac the band does not sync on the USB from the right side, only through
  the one from the left side of the laptop.
- For a couple of days the workout planner web page gave a "Oops, something
  went wrong" message.
- And I get intermitently the 'Network error' below.

![Error](/assets/2016-01-27-ms-band-review/error.png)

That is not a good first impression. I behaved like an enthusiastic early
adopter. A normal consumer would have stopped in the early stages and returned
the band.


# Second impressions

*Actually the device is well designed for fitness acivities.*

It comes at a good price, it is priced to sell. *Update:* Prices change over
time. When I wrote this article one could buy version 2 for about £170. A few
days later it was priced at about £200. At this new price it's no longer priced
to sell.

I particularly like that it is designed as what it is. It does not pretend it's
a watch. It is a wrist band packed with sensors. A watch has a dial and hands
that turn around hence the shape of a circle. Similar competitor producs
marketed for the luxury end of the market try to look like such a watch. The
Microsoft Band does not try to fake it, it is what it is.

It's display is a wide rectangle, that you access using swipe and tap
gestures, in addition to two buttons on a side. The interface is intuitive
(swipe is scroll, tap is select and buttons turn thing on and off),
with virtually no learning curve. The only downside is that when finger and
screen are slightly wet, it does not work so well.

The alarm, timer and stopwatch I would liked to have them as separate tiles (or
subtiles) rather than have to scroll withn the same tile.

The running tile is using the GPS positioning to allow you later to view the
route. It does take sometimes a few minutes to find the GPS though.

The guided workout was a pleasant surprise as it allows you to do interval
training for example: walk a minute, jog a minute, run a minute, and so on. I
started with this 'Couch to 5K' programme, though I have to sync it with a
phone or PC, or else it does not move to the next guided workout in the
programme.

Golf, I'm not doing it and it seems there is no way to hide it from the cloud
UI.

The sleep monitoring was a nice surprise. It allows you to see, when you were
in deep or light sleep, and when you were awake. It's not clear though what
exactly is the difference between deep and light sleep (it's not done on
heartbeat alone for sure). Also sometimes it claims I was awake, when actually
my wife got up, so it could be that it perceived the bed moving as me being
awake.

I'm not a fan of the notification type of applications. I think interruptions
are a big productivity killer, so I'm currently not using any ... though I find
the Calendar tempting, I currently set myself manually alarms a minute or so
ahead of meetings.

You need a few minutes daily to charge and sync it.

And there is something inconvenient about the shape when I cross my arms.

# High level application architecture

The high level application architecture looks like in the diagram below.

![Architecture](/assets/2016-01-27-ms-band-review/architecture.png)

To access this data, other than a summary, you need to pair it to a syncing
application. The band processor is not powerfull enough to do all the
HTTPS/TCP/IP/WiFi stack to talk to the cloud on it's own. It needs to be paired
to a device cappable of doing that.

There are applications for smart phones (Windows Phone, iOS,
Android), and PCs (Windows and Mac, but not for Linux). It connects to the
phone through Bluetooth, and to the PCs through the USB. It uses the USB
connector to charge. The battery lasts about 1-2 days (e.g. depending on if you
used the GPS). The syncing application allows you to configure tiles, update
the software on the band, and it uploads the data to the cloud. You can view
the data using your browser.

There are APIs to access the data:

- either from the cloud in particular Strava which is a kind of Facebook for runners
- or from the application running on the phone/PC

There are no APIs though to talk to the device directly, and no app/APIs for
Linux.

With this architecture come issues however.

The dependence from the cloud means that the applications can stop working at
any time, and I've been witness to that.

Related to the data being stored in the cloud is the issue of privacy concerns.
Having your email stored by a remote server is one thing. Having your
heart beats data stored on a remote server takes it all to a different level.

The other is a note on the fragmentation of consumer devices market. If you're
to write some application you need to cover a lot of platforms. Even a behemoth
like Microsoft is not able to write reliable, bug free, applications given this
proliferation of platforms.


# Conclussion

All in all I'm happy with the Microsoft Band for the time being, it helped me
be more active in the last month.

