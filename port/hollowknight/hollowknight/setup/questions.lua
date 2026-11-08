-- Asked by PortMaster's patcher before the setup starts (PATCHER_QUESTIONS in the launcher);
-- each answer reaches setup/patchscript as <id>=<value> in its environment.
return {
  {
    id = "TEXTURE_QUALITY",
    question = "Texture quality? High is what this port is tested with. Low makes the setup much shorter, with slightly less exact textures.",
    options = {
      { "medium", "High (recommended)" },
      { "fast", "Low (shorter setup)" },
    },
  },
}
