local mon = peripheral.find("monitor")
term.redirect(mon)
mon.clear()

local img = paintutils.loadImage("2.nfp")
paintutils.drawImage(img, 1, 1)
