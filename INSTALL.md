# Getting ZILF

In order to work with ZIL in a modern context, you'll likely need ZILF. This is an amazing piece of work but you have to know how to get it working for you.

You can check the [current downloads of ZILF](https://bitbucket.org/jmcgrew/zilf/downloads/). These are essentially how ZILF is currently distributed. Grab the latest version there.

I should note that there is a major change point in how ZILF is distributed starting with version 0.9. Prior to that, ZILF was built on [.NET Standard](https://blogs.msdn.microsoft.com/dotnet/2016/09/26/introducing-net-standard/) which meant you needed Mono to run it on non-Windows systems. Starting with version 0.9, however, the project has been written to work on [.NET Core](https://docs.microsoft.com/en-us/dotnet/core/index). This means you no longer need Mono on Linux and Mac OS.

I used to distribute the 0.8 version of ZILF as part of this project. That, however, is no longer necessary nor tenable. I recommend [getting ZILF for your operating system of choice](https://bitbucket.org/jmcgrew/zilf/downloads/).

When you extract the contents of your distribution, of importance there is the `bin` directory, which contains the ZILF and ZAPF executables.

You'll also see a `zillib` directory that provides a library of functionality for you to use. The library contains the ZILF interactive fiction library, which eventually you'll need if you want to create games. There is also a `sample` directory that contains sample games for use with the library.

If you want to use your version of ZILF directly with this project, you can simply move the directories from the distribution into this project folder.

## Make Sure ZILF Works

Now let's see if things work. ZILF and ZAPF are both managed applications that are compiled to run on the Microsoft .NET CLR, but specifically using .NET Core.

Try the following commands wherever you have place the files:

```
zilf --help
```

```
zapf --help
```

On Windows, these will be ".exe" files.

If you get some output telling you how you can use the two tools, then they are working on your machine.
