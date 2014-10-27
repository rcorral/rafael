Blog
====

This is a blog for hackers.  
It's opinionated in the way posts are written.  
Blog posts are written and configured in flat files, but are later stored in [Redis](http://redis.io/).

Writing Posts
-------------

* Post should be saved to `templates/posts`  
* Filename should follow this format:  
  `YYYY-mm-dd-post-slug.jade`  
  for example:  
  `2014-07-13-first-post.jade`  
  where the `first-post` is the slug for the URL.
* Post content should adhere to this format:  
```jade
title: 'First post'  
date: 2014-07-13T20:12
tags: ["hello"]
<!-- abstract -->
JADE
p Some text
JADE;
<!-- post -->
JADE
p some longer text
JADE;
```

Compile posts
-------------
Post files need to be parsed and then inserted into Redis.  
To do this, simply run the following command:  
`$ npm run-script build-posts`

More details
------------

1. The post files are digested by a lexical parser written in [Jison](http://zaach.github.io/jison/).
2. Posts are then entered into Redis, in two manners:
  1. `postorder` is a [Sorted Set](http://redis.io/commands#sorted_set), contains chronological order of posts
  2. `post:<post-slug>` is a [Hash](http://redis.io/commands#hash), contains all the post details

After thoughts
--------------
The `.jade` extension may not be best suited for the post files as they also contain configurations. It was chosen as it's nice to have the syntax highlighting from editors.
