# README

## Getting Started

TODO

## Technology Used

Rails, FactoryGirl, Devise, Shoulda, Omniauth

## Lessons Learnt

The authorisation logic on the models should be put in the model and not the controller.
Here I have done it two ways. The first way is with a callback on destroying and
updating a restaurant to ensure the current user is the user which created the
restaurant. See [here](https://github.com/DataMinerUK/yelp-clone/blob/master/app/models/restaurant.rb#L7-L8).
In this case, I have made the model aware of the user by passing it in [via the
controller](https://github.com/DataMinerUK/yelp-clone/blob/master/app/controllers/restaurants_controller.rb#L58-L61).
This is not a good idea as the model should not need to be aware of the user, that
is controller logic. Also, it means the restaurant cannot be updated and destroyed
at the model level without a user i.e. an admin cannot go in and do it. The better
way is to write a method in the model which takes the current user as a parameter
and does the logic of destroying/updating. This then can be called in the controller
and passed in the current user. See an example of this in the review [model](https://github.com/DataMinerUK/yelp-clone/blob/master/app/models/review.rb#L7-L12) and
[controller](https://github.com/DataMinerUK/yelp-clone/blob/master/app/controllers/reviews_controller.rb#L26-L34)
