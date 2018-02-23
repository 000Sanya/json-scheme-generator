module nullsanya.scheme.utils;

import std.json;
import std.traits : isArray, isAssociativeArray, isSigned, isUnsigned, isFloatingPoint;

template ArrayElementType(T : T[])
{
    alias ArrayElementType = T;
}

template AATypes(T : Value[Key], Value, Key)
{
    alias key = Key;
    alias value = Value;
}

bool hasType(T)(ref inout(JSONValue) value)
{
    static if(is(T == bool))
    {
        return (value.type == JSON_TYPE.TRUE || value.type == JSON_TYPE.FALSE);
    }
    else static if(is(T : real) && isFloatingPoint!T)
    {
        return value.type == JSON_TYPE.FLOAT;
    }
    else static if(is(T : ulong) && isUnsigned!T)
    {
        return value.type == JSON_TYPE.UINTEGER;
    }
    else static if(is(T : long) && isSigned!T)
    {
        return value.type == JSON_TYPE.INTEGER;
    }
    else static if(is(T == string))
    {
        return value.type == JSON_TYPE.STRING;
    }
    else static if(isArray!T)
    {
        return value.type == JSON_TYPE.ARRAY;
    }
    else static if(isAssociativeArray!T)
    {
        static if(is(AATypes!(T).key : string))
        {
            return value.type == JSON_TYPE.OBJECT;
        }
        else static assert(0, "Not supported type");
    }
    else static assert(0, "Not supported type");
}

unittest
{
    string json = q{
        {
            "a" : 3,
            "b" : 2.4,
            "c" : true,
            "d" : false,
            "e" : -3,
            "f" : "hello",
            "g" : ["1", 2, true],
            "h" : {
                "_t" : 1
            }
        }
    };
    JSONValue values = parseJSON(json);

    //assert(hasType!uint(values["a"]));
    assert(hasType!double(values["b"]));
    assert(hasType!bool(values["c"]));
    assert(hasType!bool(values["d"]));
    assert(hasType!int(values["e"]));
    assert(hasType!string(values["f"]));
    assert(hasType!(JSONValue[])(values["g"]));
    assert(hasType!(JSONValue[string])(values["h"]));
}