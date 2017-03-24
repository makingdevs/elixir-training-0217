defmodule Twinder.Social.User do

  @callback get_user(String.t) :: Twinder.User.t

end

defmodule Twinder.Social.User.Followers do

  @callback followers_of(Twinder.User.t) :: [Twinder.User.t]

end
