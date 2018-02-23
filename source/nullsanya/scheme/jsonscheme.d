module nullsanya.scheme.JSONSchema;

import std.json;
import std.exception : enforce;

alias Number = double;

class JSONSchema
{
    private string _title = null;
    private string _description = null;

    public string title() @property { return _title; }
    public string description() @property { return _description; }

    public void loadFromJSON(ref inout(JSONValue) value)
    {
        if(auto title = "title" in value)
        {
            _title = title.str;
        }
        if(auto desc = "description" in value)
        {
            _description = desc.str;
        }
    }
    
    public static JSONSchema fromJSON(ref inout(JSONValue) value) 
    {
        return null;
    }
}

unittest
{
    JSONValue json = parseJSON(`{"title":"title", "description":"desc"}`);
    JSONValue json1 = parseJSON(`{"description":"desc"}`);
    JSONValue json2 = parseJSON(`{"title":"title"}`);
    JSONSchema scheme = new JSONSchema();
    scheme.loadFromJSON(json);
    assert(scheme.title == "title");
    assert(scheme.description == "desc");

    JSONSchema scheme1 = new JSONSchema();
    scheme1.loadFromJSON(json1);
    assert(scheme1.title == null);
    assert(scheme1.description == "desc");

    JSONSchema scheme2 = new JSONSchema();
    scheme2.loadFromJSON(json2);
    assert(scheme2.title == "title");
    assert(scheme2.description == null);
}

class NumberScheme : JSONSchema
{
    private Number _multipleOf;
    private Number _minimum;
    private Number _maximum;
    private Number _exclusiveMinimum;
    private Number _exclusiveMaximum;

    public @property
    {
        Number multipleOf() { return _multipleOf; }
        Number minimum() { return _minimum; }
        Number maximum() { return _maximum; }
        Number exclusiveMinimum() { return _exclusiveMinimum; }
        Number exclusiveMaximum() { return _exclusiveMaximum; }
    }

    public override void loadFromJSON(ref inout(JSONValue) value)
    {
        super.loadFromJSON(value);
        if(auto mf = "multipleOf" in value)
        {
            enforce(mf.floating > 0, "multipleOf must be strictly greater than 0");
            _multipleOf = mf.floating;
        }
        if(auto v = "minimum" in value)
        {
            _minimum = v.floating;
        }
        if(auto v = "maximum" in value)
        {
            _maximum = v.floating;
        }
        if(auto v = "exclusiveMinimum" in value)
        {
            _exclusiveMinimum = v.floating;
        }
        if(auto v = "exclusiveMaximum" in value)
        {
            _exclusiveMaximum = v.floating;
        }
    }
}

class StringScheme : JSONSchema
{
    private size_t _minLength;
    private size_t _maxLength;
    private string _pattern;

    public @property
    {
        size_t minLength() { return _minLength; }
        size_t maxLength() { return _maxLength; }
        string pattern() { return _pattern; }
    }

    public override void loadFromJSON(ref inout(JSONValue) value)
    {
        super.loadFromJSON(value);
        if(auto v = "pattern" in value)
        {
            _pattern = v.str;
        }
    }
}

class ArrayScheme : JSONSchema
{
    private JSONSchema[] _items;
    private JSONSchema _additionalItems;
    private size_t _minItems;
    private size_t _maxItems;
    private bool _uniqueItems;
    private JSONSchema _contains;

    public @property
    {
        JSONSchema[] items() { return _items; }
        JSONSchema additionalItems() { return _additionalItems; }
        size_t minItems() { return _minItems; }
        size_t maxItems() { return _maxItems; }
        bool uniqueItems() { return _uniqueItems; }
        JSONSchema contains() { return _contains; }
    }

    public override void loadFromJSON(ref inout(JSONValue) value)
    {
        super.loadFromJSON(value);
        if(auto v = "items" in value)
        {
            if(v.type == JSON_TYPE.ARRAY)
            {
                auto array = v.array;
                _items.length = array.length;
                foreach(i, e; array) 
                {
                    auto schema = JSONSchema.fromJSON(e);
                    _items[i] = schema;
                }
            }
            else if(v.type == JSON_TYPE.OBJECT)
            {
                auto schema = JSONSchema.fromJSON(*v);
                _items.length = 1;
                _items[0] = schema;
            }
            else
            {
                enforce(0, "items must be JSONSchema or array of JSONSchema");
            }
        }
        if(auto v = "additionalItems" in value)
        {
            enforce(v.type == JSON_TYPE.OBJECT, "additionalItem must be JSONSchema");
            _additionalItems = JSONSchema.fromJSON(*v);
        }
        if(auto v = "minItems" in value)
        {
            enforce(v.type == JSON_TYPE.UINTEGER, "minItems must be uint");
            _minItems = cast(size_t) v.uinteger;
        }
        if(auto v = "maxItems" in value)
        {
            enforce(v.type == JSON_TYPE.UINTEGER, "maxItems must be uint");
            _minItems = cast(size_t) v.uinteger;
        }
        if(auto v = "uniqueItems" in value)
        {
            if(v.type == JSON_TYPE.TRUE)
            {
                _uniqueItems = true;
            }
            else if(v.type == JSON_TYPE.FALSE)
            {
                _uniqueItems = false;
            }
            else
            {
                throw new Exception("uniqueItem must be boolean");
            }
        }
        if(auto v = "contains" in value)
        {
            enforce(v.type == JSON_TYPE.OBJECT, "additionalItem must be JSONSchema");
            _contains = JSONSchema.fromJSON(*v);
        }
    }
}

class ObjectScheme : JSONSchema
{
    private JSONSchema[string] _properties;
    private JSONSchema[string] _patternProperties;
    private JSONSchema _additionalProperties;
    private Object _dependencies; // TODO: нормальный тип данных
    private string[] _required;
    private StringScheme _propertyNames;
    private size_t _minProperties;
    private size_t _maxProperties;

    public @property
    {
        JSONSchema[string] properties() { return _properties; }
        JSONSchema[string] patternProperties() { return _patternProperties; }
        JSONSchema additionalProperties() { return _additionalProperties; }
        Object dependencies() { return _dependencies; } // TODO: нормальный тип данных
        string[] required() { return _required; }
        StringScheme propertyNames() { return _propertyNames; }
        size_t minProperties() { return _minProperties; }
        size_t maxProperties() { return _maxProperties; }
    }

    public override void loadFromJSON(ref inout(JSONValue) value)
    {
        // TODO: implement
        if(auto v = "properties" in value)
        {
            
        }
        if(auto v = "patternProperties" in value)
        {
            
        }
        if(auto v = "additionalProperties" in value)
        {
            
        }
        if(auto v = "required" in value)
        {
            
        }
        if(auto v = "propertyNames" in value)
        {
            
        }
        if(auto v = "minProperties" in value)
        {
            
        }
        if(auto v = "maxProperties" in value)
        {
            
        }
    }
}

class BooleanScheme : JSONSchema { }

class NullScheme : JSONSchema { }