laptop_mic = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.pci-0000_04_00.6.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "laptop mic",
    ["node.nick"] = "laptop mic",
    ["priority.session"] = 1000,
    ["priority.driver"] = 1000,
  },
}

table.insert(alsa_monitor.rules,laptop_mic)

laptop_speaker = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_04_00.6.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "laptop speaker",
    ["node.nick"] = "laptop speaker",
    ["priority.session"] = 1000,
    ["priority.driver"] = 1000,
  },
}

table.insert(alsa_monitor.rules,laptop_speaker)

akg_headset_speaker = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Samsung_USBC_Headset_20190816-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "akg headset speaker",
    ["node.nick"] = "akg headset speaker",
    ["priority.session"] = 2050,
    ["priority.driver"] = 2050,
  },
}

table.insert(alsa_monitor.rules,akg_headset_speaker)

akg_headset_mic = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.usb-Samsung_USBC_Headset_20190816-00.mono-fallback" },
    },
  },
  apply_properties = {
    ["node.description"] = "akg headset mic",
    ["node.nick"] = "akg headset mic",
  },
}

table.insert(alsa_monitor.rules,akg_headset_mic)



gaming_headset_speaker = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "gaming headset speaker",
    ["node.nick"] = "gaming headset speaker",
    ["priority.session"] = 2000,
    ["priority.driver"] = 2000,
  },
}

table.insert(alsa_monitor.rules,gaming_headset_speaker)

gaming_headset_mic = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.mono-fallback" },
    },
  },
  apply_properties = {
    ["node.description"] = "gaming headset mic",
    ["node.nick"] = "gaming headset mic",
    ["priority.session"] = 2000,
    ["priority.driver"] = 2000,
  },
}

table.insert(alsa_monitor.rules,gaming_headset_mic)

jabra_speaker = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-GN_Audio_A_S_Jabra_Evolve2_40_A00250690C350E-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "Jabra",
    ["node.nick"] = "Jabra",
    ["priority.session"] = 2100,
    ["priority.driver"] = 2100,
  },
}

table.insert(alsa_monitor.rules,jabra_speaker)

jabra_mic = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.usb-GN_Audio_A_S_Jabra_Evolve2_40_A00250690C350E-00.mono-fallback" },
    },
  },
  apply_properties = {
    ["node.description"] = "Jabra-Mic",
    ["node.nick"] = "Jabra-Mic",
    ["priority.session"] = 2100,
    ["priority.driver"] = 2100,
  },
}

table.insert(alsa_monitor.rules,jabra_mic)



laptop_hdmi_sound_output = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_04_00.1.hdmi-stereo-extra1" },
    },
  },
  apply_properties = {
    ["node.description"] = "laptop hdmi sound output",
    ["node.nick"] = "laptop hdmi sound output",
    ["priority.session"] = 1500,
    ["priority.driver"] = 1500,
  },
}

table.insert(alsa_monitor.rules,laptop_hdmi_sound_output)

dock_sound_input = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.usb-DisplayLink_ThinkPad_Hybrid_USB-C_with_USB-A_Dock_11071684-02.iec958-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "dock sound input",
    ["node.nick"] = "dock sound input",
    ["priority.session"] = 1700,
    ["priority.driver"] = 1700,
  },
}

table.insert(alsa_monitor.rules,dock_sound_input)

dock_sound_output = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-DisplayLink_ThinkPad_Hybrid_USB-C_with_USB-A_Dock_11071684-02.iec958-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "dock sound output",
    ["node.nick"] = "dock sound output",
    ["priority.session"] = 1700,
    ["priority.driver"] = 1700,
  },
}

table.insert(alsa_monitor.rules,dock_sound_output)

-- laptop_webcam = {
--   matches = {
--     {
--       { "node.name", "equals", "v4l2_input.pci-0000_04_00.3-usb-0_3_1.0" },
--     },
--   },
--   apply_properties = {
--     ["node.description"] = "webcam",
--     ["node.nick"] = "webcam",
--   },
-- }

-- table.insert(alsa_monitor.rules,laptop_webcam)
