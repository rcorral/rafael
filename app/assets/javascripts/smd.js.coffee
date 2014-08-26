# Synchronous module definition
# https://raw.githubusercontent.com/matb33/meteor-smd/master/meteor-smd.js
do (
    self = window
) ->

    parseArgs = (args) ->
        deps = undefined
        func = null
        other = null
        name = args.shift()

        if args.length > 1
            deps = args.shift()
            func = args.shift()
        else
            val = args.shift()
            if typeof val is "function"
                func = val
            else
                other = val

        name: name
        func: func
        other: other
        deps: deps

    exec = (name, func, other, deps, ns) ->
        resolvedDeps = []
        run = false
        name = '_anonymous_' + (counter++) if name is null

        unless resolved[name]
            if deps
                # There are dependencies, run func if they are all resolved,
                # queue otherwise
                d = 0
                while d < deps.length
                    resolvedDeps.push ns[deps[d]]  if resolved[deps[d]]
                    d++
                run = true  if resolvedDeps.length is deps.length
            else
                # No deps, run
                run = true

            if run
                # All dependencies satisfied, run
                if func
                    result = func.apply(this, resolvedDeps)
                else
                    result = other
                resolved[name] = true
                ns[name] = result

                # Then run anything queued behind it that dependended on it,
                # making sure to only run each once (done inside exec)
                for key of queue[name]
                    if queue[name].hasOwnProperty(key)
                        q = queue[name][key]
                        exec.call this, q.name, q.func, q.other, q.deps, ns
                return result
            else
                # Queue up the function to each of the dependencies. We'll
                # make sure it only runs once though
                d = 0
                while d < deps.length
                    depName = deps[d]
                    queue[depName] = []  unless queue[depName]
                    queue[depName].push
                        name: name
                        func: func
                        other: other
                        deps: deps
                    d++
        return

    resolved = {}
    modules = {}
    queue = {}
    counter = 0

    self.define = -> # name, func/other || name, deps_array, func
        args = parseArgs(Array::slice.call(arguments))
        name = args.name
        func = args.func
        other = args.other
        deps = args.deps
        throw new Error "Module already defined with name: #{name}" if modules[name]
        exec.call this, name, func, other, deps, modules

    self.using = -> # deps/deps_array, func
        args = Array::slice.call(arguments)
        func = args.pop()
        deps = if args.length > 1 then args else args[0]
        self.define.call this, null, args, func
