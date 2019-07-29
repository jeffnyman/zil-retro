# Getting ZILF

In order to work with ZIL in a modern context, you'll likely need ZILF. This is an amazing piece of work  but it's not a very friendly tool in some cases and getting it setup is potentially a bit problematic if you're not supposed to setting up programming tools.

If you don't want to use the version of ZILF in this repository, I'll cover how you can get your own.

You can check the [current downloads of ZILF](https://bitbucket.org/jmcgrew/zilf/downloads/). These are essentially how ZILF is currently distributed. Grab the latest version there.

When you extract the contents, of importance there is the `bin`</code>` directory, which contains the ZILF and ZAPF executables.

The `doc`, `library` and `sample` directories are useful but they not be as up to date. To handle that last issues, at that same link as above, click the "Download repository" link. As opposed to the *last bundled up version*, this link will give you a zipped up file of all the *current* contents.

Once you extract the contents, you'll see a `zillib` directory that you should probably use for the library directory. There is a `sample` directory that contains more up to date samples than the distribution. The library contains the ZILF interactive fiction library, which eventually you'll need if you want to create games. The samples are just that: sample games for use with the library. The documentation is so threadbare as to be almost useless but it does, at the very least, give you a good idea of the tools. As far as constructing games, however, they're not that useful.

So here's what I would recommend:

1. Use `zilf-0.8` for your project folder.</li>
2. But delete everything in there except the `bin` directory.
3. Move the `zillib` directory from the distribution to your project folder and rename it `library`.
4. Move the `sample` directory from the distribution to your project folder.
5. Move the `doc` directory from the distribution to you project folder.
6. After that you can delete the distribution folder.

A bit cumbersome perhaps, but at least now everything is as up to date as it can be. Note that, to my knowledge, there is also no way to really know when there are updates to the library, samples or documentation short of just keeping your eye on the repository. And it won't necessarily be clear if those updates have been bundled into a release.

## Make Sure ZILF Works

Now let's see if things work. ZILF and ZAPF are both managed applications that are compiled to run on the Microsoft .NET CLR. On Windows this means you can run the executables directly, as long as you have the .NET runtime installed, which you likely do if you have a relatively up to date version of Windows. You have to use Mono on Linux and Mac OS in order to run the executables.

Try the following commands wherever you have place the files:

```
zilf.exe --help
```

```
zapf.exe --help
```

Again, on Mac or Linux, you have to preface those commands with `mono`.

If you get some output telling you how you can use the two tools, then they are working on your machine.
