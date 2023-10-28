module Main exposing (main)

import Css.Global
import Html.Styled as HtmlS exposing (div, text)
import Html exposing (Html)
import Html.Styled.Attributes as AttrS exposing (css)
import Tailwind.Breakpoints as TWBp
import Tailwind.Theme as Theme
import Tailwind.Utilities as Tw exposing (globalStyles)
import Browser

type Model =
    Nada


init : () -> ( Model, Cmd Msg )
init _ = (Nada, Cmd.none)


subscriptions :  Model -> Sub Msg
subscriptions modelo =
    Sub.none

type Msg =
    SinAviso

update :  Msg -> Model -> ( Model, Cmd Msg )
update mensaje _ = (Nada, Cmd.none)


main = Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

view : Model -> Html Msg
view modelo =
    div []
        [ Css.Global.global globalStyles
        , div
            [ css
                [ Tw.m_3
                , Tw.border_2
                , Tw.border_r_2
                , Tw.border_color Theme.red_400
                , Tw.p_1
                ]
            ]
            [ text "This page is just static HTML, rendered by Elm." ]
        ]          |> HtmlS.toUnstyled
