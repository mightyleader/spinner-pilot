# spinner-pilot
A simple NSString category for removing HTML and XML entities.

I just wanted to remove a bunch of ```&#38;``` and ```&lsquo;``` from some content in a JSON feed.
All the answers on how to do it looked like they didn't handle all the cases.
So I made this NSString category. 

Basically it's a single class method:

```+ (NSString *)stringByStrippingMarkupEntitiesFromString:(NSString *)string;```

Enjoy.
