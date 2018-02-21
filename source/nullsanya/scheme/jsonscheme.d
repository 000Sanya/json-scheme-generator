module nullsanya.scheme.jsonscheme;

alias Number = double;

class JSONScheme
{
    private string _title;
    private string _description;

    public string title() @property { return _title; }
    public string description() @property { return _description; }
}

class NumberScheme : JSONScheme
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
}

class StringScheme : JSONScheme
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
}

class ArrayScheme : JSONScheme
{
    private JSONScheme[] _items;
    private JSONScheme _additionalItems;
    private size_t _minItems;
    private size_t _maxItems;
    private bool _uniqueItems;
    private JSONScheme _contains;

    public @property
    {
        JSONScheme[] items() { return _items; }
        JSONScheme additionalItems() { return _additionalItems; }
        size_t minItems() { return _minItems; }
        size_t maxItems() { return _maxItems; }
        bool uniqueItems() { return _uniqueItems; }
        JSONScheme contains() { return _contains; }
    }
}

class ObjectScheme : JSONScheme
{
    private JSONScheme[string] _properties;
    private JSONScheme[string] _patternProperties;
    private JSONScheme _additionalProperties;
    private Object _dependencies; // TODO: нормальный тип данных
    private string[] _required;
    private StringScheme _propertyNames;
    private size_t _minProperties;
    private size_t _maxProperties;

    public @property
    {
        JSONScheme[string] properties() { return _properties; }
        JSONScheme[string] patternProperties() { return _patternProperties; }
        JSONScheme additionalProperties() { return _additionalPropertie; }
        Object dependencies() { return _dependencies; } // TODO: нормальный тип данных
        string[] required() { return _required; }
        StringScheme propertyNames() { return _propertyNames; }
        size_t minProperties() { return _minProperties; }
        size_t maxProperties() { return _maxProperties; }
    }
}

class BooleanScheme : JSONScheme { }

class NullScheme : JSONScheme { }