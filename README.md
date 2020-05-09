## minerva's servant

api for [minerva's akasha](https://github.com/jpegzilla/minervas-akasha)

### running

requires ruby.

to run the server, just run `rake start`. dependencies will be installed if necessary.

to run in development mode, with more logging and hot reloading, run `rake dev`.

### usage

requires mongodb / ruby / minerva's akasha

// todo...I guess I'll explain here how to set up your own minerva's akasha instance or something...when minerva's akasha reaches alpha LOL

user objects (for the `/user/` endpoints) must be in the same format as they are created in minerva's akasha, except for one difference: the `id` key must be renamed `user_id`. this is because the database being used is mongodb, which allows you to access their internally generated document id using either the `_id` or `id` field, meaning you have to use something different, like `user_id`, to avoid confilct.

user data objects must be treated similarly, but only the top level `id` key that corresponds to the user must be changed.
