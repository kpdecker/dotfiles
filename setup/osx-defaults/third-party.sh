#!/usr/bin/env bash

killall "Divvy" &> /dev/null
sleep 5

defaults write com.mizage.direct.Divvy enableAcceleration -int 1
defaults write com.mizage.direct.Divvy.globalHotkey keyCode -int 50
defaults write com.mizage.direct.Divvy.globalHotkey modifiers -int 768
defaults write com.mizage.direct.Divvy shortcuts -data "62706c6973743030d40102030405064445582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0aa07081026272e36373f4055246e756c6cd2090a0b0f5a4e532e6f626a656374735624636c617373a30c0d0e8002800580078009dd11121314150a161718191a1b1c1d1e1f2020221e231d24251f1f5873697a65526f77735f100f73656c656374696f6e456e64526f775f101173656c656374696f6e5374617274526f775a7375626469766964656456676c6f62616c5f101273656c656374696f6e456e64436f6c756d6e57656e61626c65645b73697a65436f6c756d6e73576e616d654b65795c6b6579436f6d626f436f64655f101473656c656374696f6e5374617274436f6c756d6e5d6b6579436f6d626f466c6167731006100510000808800409800310125446756c6cd228292a2b5a24636c6173736e616d655824636c61737365735853686f7274637574a22c2d5853686f7274637574584e534f626a656374dd11121314150a161718191a1b1c1d1e1f20202232231d34351f1f0808800410020980061013544c656674dd11121314150a161718191a1b1c1d1e1f2020221e231d3c3d3e1f0808800409800810141003555269676874d2282941425e4e534d757461626c654172726179a341432d574e5341727261795f100f4e534b657965644172636869766572d1464754726f6f74800100080011001a0023002d0032003700420048004d0058005f0063006500670069006b0086008f00a100b500c000c700dc00e400f000f80105011c012a012c012e0130013101320134013501370139013e0143014e015701600163016c01750190019101920194019601970199019b01a001bb01bc01bd01bf01c001c201c401c601cc01d101e001e401ec01fe020102060000000000000201000000000000004800000000000000000000000000000208"
defaults write com.mizage.direct.Divvy showMenuIcon -int 0
defaults write com.mizage.direct.Divvy useGlobalHotkey -int 1

open /Applications/Divvy.app