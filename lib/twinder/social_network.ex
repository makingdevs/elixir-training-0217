defmodule Twinder.Social.User do

  @callback user_info(String.t) :: Twinder.User.t

end
