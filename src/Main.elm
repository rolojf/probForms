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
    = FormMsg (Form.Msg Msg)
    | OnSubmitForma (Form.Validated String MiForma)


update : Msg -> Model -> ( Model, Cmd Msg )
update mensaje model =
     case mensaje of
        OnSubmitForma { parsed } ->
            case parsed of
                Form.Valid signUpData ->
                    ( { model | submitting = True }
                    , Debug.log "sendSignUpData" signUpData )
                Form.Invalid _ _ ->
                    -- validation errors are displayed already so
                    -- we don't need to do anything else here
                    ( model, Cmd.none )
        FormMsg formMsg ->
            let
                ( updatedFormModel, cmd ) =
                    Form.update formMsg model.formModel
            in
            ( { model | formModel = updatedFormModel }, cmd )



main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias MiForma =
    { nombre : String }

formView : Model -> HtmlS.Html Msg
formView model =
    laForma
        |> Form.renderStyledHtml
        { submitting = model.submitting
        , state = model.formModel
        , toMsg = FormMsg
        }
        (Form.options "form"
            |> Form.withOnSubmit OnSubmitForma
        )
        []



laForma : Form.StyledHtmlForm String MiForma input Msg
laForma =
    (\nombre ->
        { combine =
            -- Validation error parsed Never Never
            Validation.succeed
                (\nombreDado -> { nombre = nombreDado })
        , view =
            -- Context error input -> List (Html msg)
            \formState ->
                let
                    fieldView label field =
                        Html.div []
                            [ Html.label []
                                [ Html.text (label ++ " ")
                                , FieldView.input [] field
                                -- , errorsView formState field
                                ]
                            ]
                in
                [ fieldView "NOMBRE" nombre ]
        }
    )
        |> Form.form
        |> Form.field "nombre" (Field.text |> Field.required "Requerido")


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
