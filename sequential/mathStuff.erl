-module(mathStuff).
-export([perimeter/1]).

perimeter(Form) ->
    Shape = element(1, Form),
    case Shape of
        square ->
            Side = element(2, Form),
            4 * Side;
        circle ->
            Radius = element(2, Form),
            2 * 3.1415926 * Radius;
        triangle ->
            {_, A, B, C} = Form,
            A + B + C
    end.