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

`ln -s pre-commit.bash .git/hooks/pre-commit`

Or, if you're using it in a project which is a submodule of another project:

`your-main-project-name/.git/modules/your-sub-project-name/hooks/pre-commit`

Now it runs automatically and prevents you from commiting your changes unless
they conform to Idiomatic.js.

If you want to bypass your pre-commit hook, use `git commit --no-verify`.

More info: http://git-scm.com/book/en/Customizing-Git-Git-Hooks

## The Style

https://github.com/rwldrn/idiomatic.js/

