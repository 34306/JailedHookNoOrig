#import "Hook/fishhook.h"
#import "Hook/hook.h"
#import "Hook/patch.h"

/********** FISHHOOK ***********/

void (*original_function)(void *_this);
void replaced_function(void *_this) {
    if(_this != NULL){
    return;
    }
}

void fishhook_function(){
    //_TN_127 is the output name function for testing.
    rebind_symbols((struct rebinding[1]){{"_TN_127", (void *)replaced_function, (void **)&original_function}},1);
}


/****** END FISHHOOK *******/

/****** HOOK NO ORIGINAL *******/

bool _function_return1(void *_this){
    return TRUE;
}

float _function_return2(void *_this){
    return 10;
}

void _function_return3(void *_this){
    return;
}

void _function_4(void *_this){
    return;
}

void _function_5(void *_this){
    return;
}

bool _function_6(void *_this){
    return FALSE;
}

void hook_no_orig_function(){
    //This hook maximum get 6 due to Apple, all at the same time, you can hook into private region like an static address
    //with getAbsoluteAddress("image_name", 0xAddress);
    //You can also use get_image_header() if you need it
    hook(
        (void *[]) {
            (void *)getAbsoluteAddress("FEProj", 0xAABBCCD), //first address function
            (void *)getAbsoluteAddress("FEProj", 0xFF99887),
            (void *)getAbsoluteAddress("FEProj", 0x9887766),
            (void *)getAbsoluteAddress("wildrift", 0x10AABBCCD),
            (void *)getAbsoluteAddress("wildriftvn", 0x10CCDDEEF),
            (void *)getAbsoluteAddress("anogs", 0xFFEEDDC)
        },
        (void *[]) {
            (bool *)_function_return1, //matched for the first function and so on
            (void *)_function_return2,
            (void *)_function_return3,
            (void *)_function_4,
            (void *)_function_5,
            (bool *)_function_6
        },
        6); //remember to change this number to matched functions, example you input 3 functions but let this number is 6, the hook will not work.
}

/****** END HOOK ******/

%ctor{
    fishhook_function();
    hook_no_orig_function();
}