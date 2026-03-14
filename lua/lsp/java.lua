return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/usr/lib/jvm/java-21-openjdk",
                default = true,
              },
              {
                name = "JavaSE-17",
                path = "/usr/lib/jvm/java-17-openjdk",
              },
            },
          },
        },
      },
    },
  },
}
