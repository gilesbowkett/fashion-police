# Fashion Police

This project provides a pre-commit hook to validate code style. Named Fashion
Police because it shuts you down if your style doesn't pass muster.

Fashion Police enforces the JavaScript coding standard Idiomatic.js, but you
can easily repurpose it to enforce different rules and/or work against
different languages, because the design is very simple. A style guide consists
of rules. Each rule gets its own class, and must provide a `test` method which
takes a string and an `error_message` method which returns a string.

All rules in Fashion Police currently use regular expressions or similarly
simplistic code. If you want to replace that with a rock-solid, unimpeachably
correct set of rules, you'll probably need a parsing expression grammar. Pull
requests welcome.

## How To Use It

`gem install fashion-police` and follow installation instructions:

    =====================================================================
    To enforce JS code style:
      rm $(git rev-parse --git-dir)/hooks/pre-commit.sample
      echo 'fashion-police' > $(git rev-parse --git-dir)/hooks/pre-commit
      chmod 0755 $(git rev-parse --git-dir)/hooks/pre-commit
    =====================================================================

Now it should run automatically and prevent you from commiting your changes
unless your code conforms to Idiomatic.js.

If you want to bypass your pre-commit hook, use `git commit --no-verify`.

More info: http://git-scm.com/book/en/Customizing-Git-Git-Hooks

## The Style

https://github.com/rwldrn/idiomatic.js/

But: `FashionPolice` also requires four spaces per indentation level, while
Idiomatic.js recommends two. So this departs from Idiomatic, making it non-idiomatic
Idiomatic. C'est la vie.

## License

MIT.

