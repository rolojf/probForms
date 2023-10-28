module Main exposing (main)

import Browser
import Css.Global
import Form
import Form.Field as Field
import Form.FieldView as FieldView
import Form.Validation as Validation
import Html exposing (Html)
import Html.Styled as HtmlS exposing (div, text)
import Html.Styled.Attributes as AttrS exposing (css)
import Tailwind.Breakpoints as TWBp
import Tailwind.Theme as Theme
import Tailwind.Utilities as Tw exposing (globalStyles)


type alias Model =
    { formModel : Form.Model
    , submitting : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { formModel = Form.init
      , submitting = False
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions modelo =
    Sub.none


type Msg
    = SinAviso
    | FormMsg (Form.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update _ modelo =
    ( modelo, Cmd.none )


main =
    Browser.element
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
        ]
        |> HtmlS.toUnstyled
