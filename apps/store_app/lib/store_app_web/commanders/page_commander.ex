defmodule StoreAppWeb.PageCommander do
  use Drab.Commander
  # Place your event handlers here
  #
  # defhandler button_clicked(socket, sender) do
  #   set_prop socket, "#output_div", innerHTML: "Clicked the button!"
  # end
  #
  # Place you callbacks here
  #
  onload :page_loaded

  # Drab Callbacks
  def page_loaded(socket) do
    #poke socket, welcome_text: "This page has been drabbed"
    #set_prop socket, "section.jumbotron p.lead",
    #  innerHTML: "Please visit <a href='https://tg.pl/drab'>Drab</a> page for more examples and description"
  end
  #
  # def page_loaded(socket) do
  #   set_prop socket, "div.jumbotron h2", innerText: "This page has been drabbed"
  # end
end