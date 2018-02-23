module nullsanya.scheme.utils;

import std.json;

bool hasType(T)(ref inout(JSONValue) value)
{
    import std.traits : isArray, isAssociativeArray;

    static if(is(T == bool))
    {
        return (value.type == JSON_TYPE.TRUE || value.type == JSON_TYPE.FALSE);
    }
    else static if(is(T == double) || is(T == float))
    {
        return value.type == JSON_TYPE.FLOAT;
    }
    else static if(is(T == ulong) || is(T == uint))
    {
        return value.type == JSON_TYPE.UINTEGER;
    }
    else static if(is(T == long) || is(T == int))
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
        // TODO: implement
    }
    else static assert(0, "Not supported type");
}