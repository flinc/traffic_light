# Our famous traffic light at the flinc offices

![traffic light at the flinc office](http://i.imgur.com/3ZX9R.jpg)

## What it does

It is connected against our [CI Joe](https://github.com/defunkt/cijoe) continuous integration server to show us the current status of our checked-in specs/code. :)

* Red: Specs failed! 
* Yellow: Specs are currently running on CI Joe.
* Green: Specs passed! :D

Aaand... of course we have a nice web interface:

![traffic light web interface](http://dl.dropbox.com/u/1523969/screenshots/traffic_light_webinterface.png)

## How it works

The lights of the traffic light are controlled by a [K8055 usb board](http://www.velleman.eu/distributor/products/view/?country=be&lang=de&id=351346).

Actually, we replaced the light bulbs in the traffic lights with LED clusters to save energy. :3

A complete [wiring diagram](https://github.com/flinc/traffic_light/blob/master/res/wiring_diagram.pdf) is included.

We use a command line to control the usb board, so you have to compile a `k8055` binary from [here](http://soft.pmad.net/k8055).

Note: We managed to do this on OS X Snow Leopard as well as on BusyBox (to run it on a [DiskStation NAS](http://www.synology.com/products/product.php?product_name=DS110j&lang=enu)).

## Special Thanks

A very special "Thank you!" goes to Markus Kinkel who created the wiring diagram and built the electronics of the traffic light. :)

We hope you enjoy it! :)