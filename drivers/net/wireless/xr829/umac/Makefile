obj-$(CONFIG_XRMAC) += xr829_mac.o

ldflags-y += --strip-debug
# xr829_mac objects
xr829_mac-y := \
	main.o status.o \
	sta_info.o \
	wep.o \
	wpa.o \
	wapi.o \
	scan.o offchannel.o \
	ht.o agg-tx.o agg-rx.o \
	ibss.o \
	mlme.o work.o \
	iface.o \
	rate.o \
	michael.o \
	tkip.o \
	aes_ccm.o \
	aes_cmac.o \
	cfg.o \
	rx.o \
	spectmgmt.o \
	tx.o \
	key.o \
	util.o \
	wme.o \
	event.o \
	average.o \
	chan.o

xr829_mac-$(CONFIG_XRMAC_LEDS) += led.o
xr829_mac-$(CONFIG_XRMAC_DEBUGFS) += \
	debugfs.o \
	debugfs_sta.o \
	debugfs_netdev.o \
	debugfs_key.o

xr829_mac-$(CONFIG_XRMAC_MESH) += \
	mesh.o \
	mesh_pathtbl.o \
	mesh_plink.o \
	mesh_hwmp.o

xr829_mac-$(CONFIG_PM) += pm.o

xr829_mac-$(CONFIG_XRMAC_DRIVER_API_TRACER) += driver-trace.o
CFLAGS_driver-trace.o := -I$(src)

# objects for PID algorithm
rc80211_pid-y := rc80211_pid_algo.o
rc80211_pid-$(CONFIG_XRMAC_DEBUGFS) += rc80211_pid_debugfs.o

rc80211_minstrel-y := rc80211_minstrel.o
rc80211_minstrel-$(CONFIG_XRMAC_DEBUGFS) += rc80211_minstrel_debugfs.o

rc80211_minstrel_ht-y := rc80211_minstrel_ht.o
rc80211_minstrel_ht-$(CONFIG_XRMAC_DEBUGFS) += rc80211_minstrel_ht_debugfs.o

xr829_mac-$(CONFIG_XRMAC_RC_PID) += $(rc80211_pid-y)
xr829_mac-$(CONFIG_XRMAC_RC_MINSTREL) += $(rc80211_minstrel-y)
xr829_mac-$(CONFIG_XRMAC_RC_MINSTREL_HT) += $(rc80211_minstrel_ht-y)

ccflags-y += -D__CHECK_ENDIAN__
# Extra IE for probe response from upper layer is needed in P2P GO
# For offloading probe response to FW, the extra IE must be included
# in the probe response template
ccflags-y += -DPROBE_RESP_EXTRA_IE
ccflags-y += -DIPV6_FILTERING
# PocketForge (tsp-rcb): host-side reassociation-latency optimization (TX-queue
# lock during auth/assoc + deferred HW key teardown while roaming).
# DISABLED 2026-06-22: enabling it OOPSed the kernel in __ieee80211_key_destroy
# (umac/key.c:459-488) during nl80211_new_key — the change adds a non-blocking
# call_rcu() key-free path taken whenever ifmgd->roaming==1 (set on every reassoc,
# mlme.c:2851), which races key teardown on this fork and floods "[RX] No key
# found" -> unjoin -> WiFi down. The vendor shipped it disabled for a reason.
# Re-enabling needs a targeted fix to that async-free path (NOT all-or-nothing);
# tracked as follow-up under tsp-rcb. Split-scan (wlan/scan.c) + FT-PSK are kept.
#ccflags-y += -DCONFIG_XRMAC_XR_ROAMING_CHANGES
ccflags-y += -DUSE_RSSI_SMOOTH
