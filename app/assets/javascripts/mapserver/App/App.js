var App = {

    newClass: function (definition) {
        var constructor = definition.constructor;
        var parent = definition.Extends;
        if (parent) {
            var F = function () { };
            constructor._superClass = F.prototype = parent.prototype;
            constructor.prototype = new F();
        }
        for (var key in definition) {
            constructor.prototype[key] = definition[key];
        }
        constructor.prototype.constructor = constructor;

        return constructor;
    }

};