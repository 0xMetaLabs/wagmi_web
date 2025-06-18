part of '../wagmi.js.dart';

extension JSFunctionToDart on JSFunction {
  Function get toDart {
    // For WASM compatibility, we need to handle the conversion differently
    try {
      return dartify()! as Function;
    } catch (e) {
      // Fallback for WASM - create a wrapper function
      final jsFunc = this; // Capture the function reference
      return ([dynamic a1, dynamic a2, dynamic a3, dynamic a4]) {
        final args = <JSAny?>[];
        if (a1 != null) args.add(UtilsJS.jsify(a1));
        if (a2 != null) args.add(UtilsJS.jsify(a2));
        if (a3 != null) args.add(UtilsJS.jsify(a3));
        if (a4 != null) args.add(UtilsJS.jsify(a4));

        // Call with individual arguments (max 4 args + this context = 5 total)
        switch (args.length) {
          case 0:
            return jsFunc.callAsFunction();
          case 1:
            return jsFunc.callAsFunction(null, args[0]);
          case 2:
            return jsFunc.callAsFunction(null, args[0], args[1]);
          case 3:
            return jsFunc.callAsFunction(null, args[0], args[1], args[2]);
          case 4:
            return jsFunc.callAsFunction(
                null, args[0], args[1], args[2], args[3]);
          default:
            return jsFunc.callAsFunction();
        }
      };
    }
  }
}
