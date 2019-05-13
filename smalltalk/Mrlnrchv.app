

Application create: #MerlinArchive with:
    (#( AbtBuildInterfacesApp AbtBuildViewsApp Merlin)
        collect: [:each | Smalltalk at: each ifAbsent: [
            Application errorPrerequisite: #MerlinArchive missing: each]])!

MerlinArchive becomeDefault!
Application subclass: #MerlinArchive
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''!


MerlinArchive becomeDefault!

!Cookable class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the Cookable."
	" Cookable reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #name put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #String;
			attributeSettingNamed: #setSelector put: #name:;
			attributeSettingNamed: #getSelector put: #name;
			attributeSettingNamed: #changeSymbol put: #name);
		featureBuilderNamed: #description put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #String;
			attributeSettingNamed: #setSelector put: #description:;
			attributeSettingNamed: #getSelector put: #description;
			attributeSettingNamed: #changeSymbol put: #description);
		featureBuilderNamed: #time put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #time:;
			attributeSettingNamed: #getSelector put: #time;
			attributeSettingNamed: #changeSymbol put: #time)! !


!CookableManager class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the CookableManager."
	" CookableManager reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #contained put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #OrderedCollection;
			attributeSettingNamed: #secondaryPartType put: #Cookable;
			attributeSettingNamed: #setSelector put: #contained:;
			attributeSettingNamed: #getSelector put: #contained;
			attributeSettingNamed: #changeSymbol put: #contained);
		featureBuilderNamed: #remove: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aCookable');
				 yourself);
			attributeSettingNamed: #selector put: #remove:);
		featureBuilderNamed: #add: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aCookableObject');
				 yourself);
			attributeSettingNamed: #selector put: #add:);
		featureBuilderNamed: #recalculatePrice put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculatePrice);
		featureBuilderNamed: #totalPrice put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalPrice:;
			attributeSettingNamed: #getSelector put: #totalPrice;
			attributeSettingNamed: #changeSymbol put: #totalPrice);
		featureBuilderNamed: #totalWeight put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalWeight:;
			attributeSettingNamed: #getSelector put: #totalWeight;
			attributeSettingNamed: #changeSymbol put: #totalWeight);
		featureBuilderNamed: #recalculateWeight put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculateWeight);
		featureBuilderNamed: #recalculateBag put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculateBag);
		featureBuilderNamed: #ingredientBag put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #OrderedCollection;
			attributeSettingNamed: #secondaryPartType put: #Cookable;
			attributeSettingNamed: #setSelector put: #ingredientBag:;
			attributeSettingNamed: #getSelector put: #ingredientBag;
			attributeSettingNamed: #changeSymbol put: #ingredientBag);
		featureBuilderNamed: #totalTime put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalTime:;
			attributeSettingNamed: #getSelector put: #totalTime;
			attributeSettingNamed: #changeSymbol put: #totalTime);
		featureBuilderNamed: #recalculateTime put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculateTime)! !


!Ingredient class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the Ingredient."
	" Ingredient reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #weight put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #weight:;
			attributeSettingNamed: #getSelector put: #weight;
			attributeSettingNamed: #changeSymbol put: #weight);
		featureBuilderNamed: #price put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Decimal;
			attributeSettingNamed: #setSelector put: #price:;
			attributeSettingNamed: #getSelector put: #price;
			attributeSettingNamed: #changeSymbol put: #price)! !


!IngredientManager class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the IngredientManager."
	" IngredientManager reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #edit: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aIngredient');
				 yourself);
			attributeSettingNamed: #selector put: #edit:);
		featureBuilderNamed: #addNew put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #addNew);
		featureBuilderNamed: #manage put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #manage)! !


!IngredientManagerView class publicMethods !

calculatePartBuilder
	"Create the edit time part tree for the IngredientManagerView."
	" IngredientManagerView recalculatePartBuilderRecordFromArchivalCode. "

	| anIngredientManagerView |

	anIngredientManagerView := self newTopLevelPartBuilder.

	anIngredientManagerView
		 subpartBuilderNamed: 'Window'
			 put: (self addWindowPartBuilder: anIngredientManagerView);
		 subpartBuilderNamed: 'Ingredient Manager Var'
			 put: ((IngredientManager) newVariableBuilder).

	anIngredientManagerView
		 attributeSettingNamed: #primaryPart put: (anIngredientManagerView subpartBuilderNamed: 'Window').

	self connectIngredientManagerView: anIngredientManagerView.

	^anIngredientManagerView! !

!IngredientManagerView class privateMethods !

addAddRecipePartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Add';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 248);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 97);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 204);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addLabel1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Ingredients';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 14);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 9);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addList1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 13);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 345);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 31);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 158)).

	^anAbtListView!

addPushButton1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Edit';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 133);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 97);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 204);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addPushButton2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'OK';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 212);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 88);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 244);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addPushButton3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Cancel';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 62);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 88);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 244);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addRemoveRecipePartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Remove';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 18);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 97);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 204);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addWindowPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtShellView."

	| anAbtShellView |

	anAbtShellView := AbtShellView newSubpartBuilder.

	anAbtShellView
		 subpartBuilderNamed: 'RemoveRecipe'
			 put: (self addRemoveRecipePartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button1'
			 put: (self addPushButton1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'AddRecipe'
			 put: (self addAddRecipePartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List1'
			 put: (self addList1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label1'
			 put: (self addLabel1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button3'
			 put: (self addPushButton3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button2'
			 put: (self addPushButton2PartBuilder: anAbtShellView).

	anAbtShellView
		 attributeSettingNamed: #shellDecorations put: 122;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEdgeConstant new
				offset: 60);
			rightEdge: (AbtEdgeConstant new
				offset: 363);
			topEdge: (AbtEdgeConstant new
				offset: 32);
			bottomEdge: (AbtEdgeConstant new
				offset: 282));
		 attributeSettingNamed: #title put: 'Ingredient Manager'.

	^anAbtShellView!

calculateInterfaceSpec
	"Create the interface specification for the IngredientManagerView."
	" IngredientManagerView reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #aIngredientManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #IngredientManager;
			attributeSettingNamed: #setSelector put: #aIngredientManager:;
			attributeSettingNamed: #getSelector put: #aIngredientManager;
			attributeSettingNamed: #changeSymbol put: #aIngredientManager);
		featureBuilderNamed: #result put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Boolean;
			attributeSettingNamed: #setSelector put: #result:;
			attributeSettingNamed: #getSelector put: #result;
			attributeSettingNamed: #changeSymbol put: #result);
		featureBuilderNamed: #returnTrue put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnTrue);
		featureBuilderNamed: #returnFalse put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnFalse)!

codeGenerationParameters: builder
	^IdentityDictionary new
		yourself!

connectIngredientManagerView: aTopLevelPartBuilder
	"Create the edit time part tree for the IngredientManagerView."

	aTopLevelPartBuilder
		 connectionBuilderAt: 3
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #selectionIsValid;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RemoveRecipe');
				 targetAttributeName: #enabled);
		 connectionBuilderAt: 4
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 sourceAttributeName: #enabled;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 targetAttributeName: #selectionIsValid);
		 connectionBuilderAt: 5
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 6
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 7
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RemoveRecipe');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 actionName: #remove:);
		 connectionBuilderAt: 8
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 7);
				 targetAttributeName: 'aCookable');
		 connectionBuilderAt: 9
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 actionName: #edit:);
		 connectionBuilderAt: 10
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 9);
				 targetAttributeName: 'aIngredient');
		 connectionBuilderAt: 11
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'AddRecipe');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 actionName: #addNew);
		 connectionBuilderAt: 12
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #items;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 targetAttributeName: #contained);
		 connectionBuilderAt: 23
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aIngredientManager);
		 connectionBuilderAt: 24
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse);
		 connectionBuilderAt: 25
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnTrue);
		 connectionBuilderAt: 16
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #openedWidget;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse).

	^aTopLevelPartBuilder!

test
	" Test creating the view. "
	" IngredientManagerView recalculatePartBuilderRecordFromArchivalCode.  "
	" IngredientManagerView test  "

	IngredientManagerView newInShellView openWidget.! !


!IngredientView class publicMethods !

calculatePartBuilder
	"Create the edit time part tree for the IngredientView."
	" IngredientView recalculatePartBuilderRecordFromArchivalCode. "

	| anIngredientView |

	anIngredientView := self newTopLevelPartBuilder.

	anIngredientView
		 subpartBuilderNamed: 'Window'
			 put: (self addWindowPartBuilder: anIngredientView);
		 subpartBuilderNamed: 'aIngredient'
			 put: ((Ingredient) newVariableBuilder).

	anIngredientView
		 attributeSettingNamed: #primaryPart put: (anIngredientView subpartBuilderNamed: 'Window').

	self connectIngredientView: anIngredientView.

	^anIngredientView! !

!IngredientView class privateMethods !

addDescriptionField1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate5PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 433);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 152);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtTextView!

addDescriptionFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterPartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 143);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 38);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtTextView!

addDescriptionLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #description;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 52);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 81);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 39);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 21)).

	^anAbtLabelView!

addNameFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate2PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 143);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 7);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtTextView!

addNameLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #name;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 52);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 81);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 9);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 21)).

	^anAbtLabelView!

addPriceFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate3PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 143);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 69);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 24)).

	^anAbtTextView!

addPriceLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #price;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 52);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 81);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 69);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 21)).

	^anAbtLabelView!

addPushButton1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'OK';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 186);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 72);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 136);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Cancel';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 58);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 72);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 136);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addWeightFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate4PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 143);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 100);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtTextView!

addWeightLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #weight;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 52);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 81);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 99);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 21)).

	^anAbtLabelView!

addWindowPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtShellView."

	| anAbtShellView |

	anAbtShellView := AbtShellView newSubpartBuilder.

	anAbtShellView
		 subpartBuilderNamed: 'descriptionLabel'
			 put: (self addDescriptionLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'descriptionField'
			 put: (self addDescriptionFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'nameLabel'
			 put: (self addNameLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'nameField'
			 put: (self addNameFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'priceLabel'
			 put: (self addPriceLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'priceField'
			 put: (self addPriceFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'weightLabel'
			 put: (self addWeightLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'weightField'
			 put: (self addWeightFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button1'
			 put: (self addPushButton1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button2'
			 put: (self addPushButton2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'descriptionField1'
			 put: (self addDescriptionField1PartBuilder: anAbtShellView).

	anAbtShellView
		 attributeSettingNamed: #shellDecorations put: 122;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEdgeConstant new
				offset: 126);
			rightEdge: (AbtEdgeConstant new
				offset: 314);
			topEdge: (AbtEdgeConstant new
				offset: 61);
			bottomEdge: (AbtEdgeConstant new
				offset: 169));
		 attributeSettingNamed: #title put: 'Ingredient'.

	^anAbtShellView!

calculateInterfaceSpec
	"Create the interface specification for the IngredientView."
	" IngredientView reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #aIngredient put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Ingredient;
			attributeSettingNamed: #setSelector put: #aIngredient:;
			attributeSettingNamed: #getSelector put: #aIngredient;
			attributeSettingNamed: #changeSymbol put: #aIngredient);
		featureBuilderNamed: #result put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Boolean;
			attributeSettingNamed: #setSelector put: #result:;
			attributeSettingNamed: #getSelector put: #result;
			attributeSettingNamed: #changeSymbol put: #result);
		featureBuilderNamed: #returnTrue put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnTrue);
		featureBuilderNamed: #returnFalse put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnFalse)!

codeGenerationParameters: builder
	^IdentityDictionary new
		yourself!

connectIngredientView: aTopLevelPartBuilder
	"Create the edit time part tree for the IngredientView."

	aTopLevelPartBuilder
		 connectionBuilderAt: 7
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 8
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 17
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'priceField');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aIngredient');
				 targetAttributeName: #price);
		 connectionBuilderAt: 18
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'weightField');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aIngredient');
				 targetAttributeName: #weight);
		 connectionBuilderAt: 19
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'descriptionField');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aIngredient');
				 targetAttributeName: #description);
		 connectionBuilderAt: 29
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'nameField');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aIngredient');
				 targetAttributeName: #name);
		 connectionBuilderAt: 9
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aIngredient');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aIngredient);
		 connectionBuilderAt: 20
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse);
		 connectionBuilderAt: 11
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnTrue);
		 connectionBuilderAt: 12
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #openedWidget;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse).

	^aTopLevelPartBuilder!

converterDuplicate2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtStringConverter."

	| anAbtStringConverter |

	anAbtStringConverter := AbtStringConverter newTopLevelPartBuilder.

	^anAbtStringConverter!

converterDuplicate3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtDecimalConverter."

	| anAbtDecimalConverter |

	anAbtDecimalConverter := AbtDecimalConverter newTopLevelPartBuilder.

	^anAbtDecimalConverter!

converterDuplicate4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtNumberConverter."

	| anAbtNumberConverter |

	anAbtNumberConverter := AbtNumberConverter newTopLevelPartBuilder.

	^anAbtNumberConverter!

converterDuplicate5PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtStringConverter."

	| anAbtStringConverter |

	anAbtStringConverter := AbtStringConverter newTopLevelPartBuilder.

	^anAbtStringConverter!

converterPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtStringConverter."

	| anAbtStringConverter |

	anAbtStringConverter := AbtStringConverter newTopLevelPartBuilder.

	^anAbtStringConverter!

test
	" Test creating the view. "
	" IngredientView recalculatePartBuilderRecordFromArchivalCode.  "
	" IngredientView test  "

	IngredientView newInShellView openWidget.! !


!MerlinCook class publicMethods !

calculatePartBuilder
	"Create the edit time part tree for the MerlinCook."
	" MerlinCook recalculatePartBuilderRecordFromArchivalCode. "

	| aMerlinCook |

	aMerlinCook := self newTopLevelPartBuilder.

	aMerlinCook
		 subpartBuilderNamed: 'Window'
			 put: (self addWindowPartBuilder: aMerlinCook);
		 subpartBuilderNamed: 'Existing Recipes'
			 put: (self addExistingRecipesPartBuilder: aMerlinCook);
		 subpartBuilderNamed: 'Existing Ingredients'
			 put: (self addExistingIngredientsPartBuilder: aMerlinCook);
		 subpartBuilderNamed: 'Merlin Cook Book'
			 put: (self addMerlinCookBookPartBuilder: aMerlinCook).

	aMerlinCook
		 attributeSettingNamed: #primaryPart put: (aMerlinCook subpartBuilderNamed: 'Window').

	self connectMerlinCook: aMerlinCook.

	^aMerlinCook! !

!MerlinCook class privateMethods !

addExistingIngredientsPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the IngredientManager."

	| anIngredientManager |

	anIngredientManager := IngredientManager newSubpartBuilder.

	^anIngredientManager!

addExistingRecipesPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the RecipeManager."

	| aRecipeManager |

	aRecipeManager := RecipeManager newSubpartBuilder.

	^aRecipeManager!

addLabel1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Existing Ingredients';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 68);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 145);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 6);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Existing Recipes';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 281);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 145);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 6);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total price:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 258);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 279);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel41PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total cooking time:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 258);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 314);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total weight:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 258);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 296);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel5PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'ingredients to buy:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 17);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 164);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel61PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_price';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 388);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 279);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel62PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_time';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 389);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 312);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel6PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_weight';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 388);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 296);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addList1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 20);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 219);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 29);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 75)).

	^anAbtListView!

addList2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 262);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 219);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 29);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 75)).

	^anAbtListView!

addList3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 254);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 219);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 199);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 78)).

	^anAbtListView!

addList4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 17);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 219);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 185);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 142)).

	^anAbtListView!

addMerlinCookBookPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the RecipeManager."

	| aRecipeManager |

	aRecipeManager := RecipeManager newSubpartBuilder.

	^aRecipeManager!

addPushButton1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Manage Ingredients';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 60);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 113);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Manage Recipes';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 302);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 139);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 112);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Plan';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 383);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 56);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 163);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Unplan';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 303);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 163);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addWindowPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtShellView."

	| anAbtShellView |

	anAbtShellView := AbtShellView newSubpartBuilder.

	anAbtShellView
		 subpartBuilderNamed: 'List1'
			 put: (self addList1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List2'
			 put: (self addList2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label1'
			 put: (self addLabel1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label2'
			 put: (self addLabel2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button1'
			 put: (self addPushButton1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button2'
			 put: (self addPushButton2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List3'
			 put: (self addList3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button3'
			 put: (self addPushButton3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button4'
			 put: (self addPushButton4PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label3'
			 put: (self addLabel3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label4'
			 put: (self addLabel4PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label6'
			 put: (self addLabel6PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label61'
			 put: (self addLabel61PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List4'
			 put: (self addList4PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label5'
			 put: (self addLabel5PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label41'
			 put: (self addLabel41PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label62'
			 put: (self addLabel62PartBuilder: anAbtShellView).

	anAbtShellView
		 attributeSettingNamed: #allowShellResize put: false;
		 attributeSettingNamed: #iconic put: false;
		 attributeSettingNamed: #shellDecorations put: 58;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEdgeConstant new
				offset: 107);
			rightEdge: (AbtEdgeConstant new
				offset: 501);
			topEdge: (AbtEdgeConstant new
				offset: 28);
			bottomEdge: (AbtEdgeConstant new
				offset: 338));
		 attributeSettingNamed: #title put: 'Merlin Goes Cooking (c) D.D. & V.N. 1997 - All Rights Reserved'.

	^anAbtShellView!

calculateInterfaceSpec
	"Create the interface specification for the MerlinCook."
	" MerlinCook reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #LocalRecipeManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #RecipeManager;
			attributeSettingNamed: #setSelector put: #localRecipeManager:;
			attributeSettingNamed: #getSelector put: #localRecipeManager;
			attributeSettingNamed: #changeSymbol put: #LocalRecipeManager);
		featureBuilderNamed: #LocalIngredientManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #IngredientManager;
			attributeSettingNamed: #setSelector put: #localIngredientManager:;
			attributeSettingNamed: #getSelector put: #localIngredientManager;
			attributeSettingNamed: #changeSymbol put: #LocalIngredientManager);
		featureBuilderNamed: #MerlinRecipeManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #RecipeManager;
			attributeSettingNamed: #setSelector put: #merlinRecipeManager:;
			attributeSettingNamed: #getSelector put: #merlinRecipeManager;
			attributeSettingNamed: #changeSymbol put: #MerlinRecipeManager);
		featureBuilderNamed: #TotalWeight put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalWeight:;
			attributeSettingNamed: #getSelector put: #totalWeight;
			attributeSettingNamed: #changeSymbol put: #TotalWeight);
		featureBuilderNamed: #TotalPrice put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalPrice:;
			attributeSettingNamed: #getSelector put: #totalPrice;
			attributeSettingNamed: #changeSymbol put: #TotalPrice)!

codeGenerationParameters: builder
	^IdentityDictionary new
		yourself!

connectMerlinCook: aTopLevelPartBuilder
	"Create the edit time part tree for the MerlinCook."

	aTopLevelPartBuilder
		 connectionBuilderAt: 0
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #items;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Ingredients');
				 targetAttributeName: #contained);
		 connectionBuilderAt: 1
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Recipes');
				 sourceAttributeName: #contained;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 targetAttributeName: #items);
		 connectionBuilderAt: 3
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Recipes');
				 actionName: #manage);
		 connectionBuilderAt: 4
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Ingredients');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Recipes');
				 targetAttributeName: #aIngredientManager);
		 connectionBuilderAt: 16
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Ingredients');
				 actionName: #manage);
		 connectionBuilderAt: 5
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 sourceAttributeName: #selectionIsValid;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 targetAttributeName: #enabled);
		 connectionBuilderAt: 6
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Recipes');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #LocalRecipeManager);
		 connectionBuilderAt: 7
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Ingredients');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #LocalIngredientManager);
		 connectionBuilderAt: 8
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 sourceAttributeName: #contained;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List3');
				 targetAttributeName: #items);
		 connectionBuilderAt: 9
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #add:);
		 connectionBuilderAt: 10
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 9);
				 targetAttributeName: 'aCookableObject');
		 connectionBuilderAt: 11
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #MerlinRecipeManager);
		 connectionBuilderAt: 12
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button4');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #remove:);
		 connectionBuilderAt: 13
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List3');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 12);
				 targetAttributeName: 'aCookable');
		 connectionBuilderAt: 14
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List3');
				 sourceAttributeName: #selectionIsValid;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button4');
				 targetAttributeName: #enabled);
		 connectionBuilderAt: 26
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label6');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 targetAttributeName: #totalWeight);
		 connectionBuilderAt: 17
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #aboutToOpenWidget;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #recalculatePrice);
		 connectionBuilderAt: 18
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #aboutToOpenWidget;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #recalculateWeight);
		 connectionBuilderAt: 28
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label61');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 targetAttributeName: #totalPrice);
		 connectionBuilderAt: 19
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List4');
				 sourceAttributeName: #items;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 targetAttributeName: #ingredientBag);
		 connectionBuilderAt: 21
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Existing Recipes');
				 eventName: #update;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #recalculateBag);
		 connectionBuilderAt: 22
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label62');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 targetAttributeName: #totalTime);
		 connectionBuilderAt: 32
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #aboutToOpenWidget;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Merlin Cook Book');
				 actionName: #recalculateTime).

	^aTopLevelPartBuilder!

test
	" Test creating the view. "
	" MerlinCook recalculatePartBuilderRecordFromArchivalCode.  "
	" MerlinCook test  "

	MerlinCook newInShellView openWidget.! !


!Recipe class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the Recipe."
	" Recipe reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #ingredients put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #OrderedCollection;
			attributeSettingNamed: #secondaryPartType put: #Cookable;
			attributeSettingNamed: #setSelector put: #ingredients:;
			attributeSettingNamed: #getSelector put: #ingredients;
			attributeSettingNamed: #changeSymbol put: #ingredients);
		featureBuilderNamed: #salePrice put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Decimal;
			attributeSettingNamed: #setSelector put: #salePrice:;
			attributeSettingNamed: #getSelector put: #salePrice;
			attributeSettingNamed: #changeSymbol put: #salePrice);
		featureBuilderNamed: #time put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #time:;
			attributeSettingNamed: #getSelector put: #time;
			attributeSettingNamed: #changeSymbol put: #time);
		featureBuilderNamed: #add: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aIngredient');
				 yourself);
			attributeSettingNamed: #selector put: #add:);
		featureBuilderNamed: #remove: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aIngredient');
				 yourself);
			attributeSettingNamed: #selector put: #remove:);
		featureBuilderNamed: #weight put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #weight);
		featureBuilderNamed: #saleWeight put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #saleWeight:;
			attributeSettingNamed: #getSelector put: #saleWeight;
			attributeSettingNamed: #changeSymbol put: #saleWeight);
		featureBuilderNamed: #saleTime put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #saleTime:;
			attributeSettingNamed: #getSelector put: #saleTime;
			attributeSettingNamed: #changeSymbol put: #saleTime)! !


!RecipeManager class privateMethods !

calculateInterfaceSpec
	"Create the interface specification for the RecipeManager."
	" RecipeManager reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #addNew put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #addNew);
		featureBuilderNamed: #edit: put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 add: (AbtParameterSpec new parameterType: Object; parameterName: 'aRecipe');
				 yourself);
			attributeSettingNamed: #selector put: #edit:);
		featureBuilderNamed: #update put: (AbtEventSpec newFeatureBuilder
			attributeSettingNamed: #symbol put: #update);
		featureBuilderNamed: #manage put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #manage);
		featureBuilderNamed: #aIngredientManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #IngredientManager;
			attributeSettingNamed: #setSelector put: #aIngredientManager:;
			attributeSettingNamed: #getSelector put: #aIngredientManager;
			attributeSettingNamed: #changeSymbol put: #aIngredientManager)! !


!RecipeManagerView class publicMethods !

calculatePartBuilder
	"Create the edit time part tree for the RecipeManagerView."
	" RecipeManagerView recalculatePartBuilderRecordFromArchivalCode. "

	| aRecipeManagerView |

	aRecipeManagerView := self newTopLevelPartBuilder.

	aRecipeManagerView
		 subpartBuilderNamed: 'Window'
			 put: (self addWindowPartBuilder: aRecipeManagerView);
		 subpartBuilderNamed: 'Recipe Manager Var'
			 put: ((RecipeManager) newVariableBuilder).

	aRecipeManagerView
		 attributeSettingNamed: #primaryPart put: (aRecipeManagerView subpartBuilderNamed: 'Window').

	self connectRecipeManagerView: aRecipeManagerView.

	^aRecipeManagerView! !

!RecipeManagerView class privateMethods !

addAddRecipePartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Add';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 258);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 97);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 161);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addLabel1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #'Available Recipes';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 7);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 14);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addPushButton1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Edit';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 134);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 94);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 162);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 24)).

	^anAbtPushButtonView!

addPushButton2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'OK';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 214);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 88);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 203);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Cancel';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 61);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 88);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 203);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addRecipesListPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 3);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 356);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 34);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 109)).

	^anAbtListView!

addRemoveRecipePartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Remove';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 12);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 97);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 161);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 26)).

	^anAbtPushButtonView!

addWindowPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtShellView."

	| anAbtShellView |

	anAbtShellView := AbtShellView newSubpartBuilder.

	anAbtShellView
		 subpartBuilderNamed: 'Label1'
			 put: (self addLabel1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'RecipesList'
			 put: (self addRecipesListPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'AddRecipe'
			 put: (self addAddRecipePartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'RemoveRecipe'
			 put: (self addRemoveRecipePartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button1'
			 put: (self addPushButton1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button2'
			 put: (self addPushButton2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button3'
			 put: (self addPushButton3PartBuilder: anAbtShellView).

	anAbtShellView
		 attributeSettingNamed: #shellDecorations put: 122;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEdgeConstant new
				offset: 39);
			rightEdge: (AbtEdgeConstant new
				offset: 366);
			topEdge: (AbtEdgeConstant new
				offset: 20);
			bottomEdge: (AbtEdgeConstant new
				offset: 240));
		 attributeSettingNamed: #title put: 'Recipe Manager'.

	^anAbtShellView!

calculateInterfaceSpec
	"Create the interface specification for the RecipeManagerView."
	" RecipeManagerView reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #addPressed put: (AbtSubpartEventSpec newFeatureBuilder
			attributeSettingNamed: #symbol put: #addPressed;
			attributeSettingNamed: #subpartFeatureName put: #clicked;
			attributeSettingNamed: #subpartName put: 'AddRecipe');
		featureBuilderNamed: #aRecipeManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #RecipeManager;
			attributeSettingNamed: #setSelector put: #aRecipeManager:;
			attributeSettingNamed: #getSelector put: #aRecipeManager;
			attributeSettingNamed: #changeSymbol put: #aRecipeManager);
		featureBuilderNamed: #aIngredientManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #IngredientManager;
			attributeSettingNamed: #setSelector put: #aIngredientManager:;
			attributeSettingNamed: #getSelector put: #aIngredientManager;
			attributeSettingNamed: #changeSymbol put: #aIngredientManager);
		featureBuilderNamed: #result put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Boolean;
			attributeSettingNamed: #setSelector put: #result:;
			attributeSettingNamed: #getSelector put: #result;
			attributeSettingNamed: #changeSymbol put: #result);
		featureBuilderNamed: #returnTrue put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnTrue);
		featureBuilderNamed: #returnFalse put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnFalse)!

codeGenerationParameters: builder
	^IdentityDictionary new
		yourself!

connectRecipeManagerView: aTopLevelPartBuilder
	"Create the edit time part tree for the RecipeManagerView."

	aTopLevelPartBuilder
		 connectionBuilderAt: 13
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RecipesList');
				 sourceAttributeName: #selectionIsValid;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RemoveRecipe');
				 targetAttributeName: #enabled);
		 connectionBuilderAt: 1
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RemoveRecipe');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 actionName: #remove:);
		 connectionBuilderAt: 2
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RecipesList');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 1);
				 targetAttributeName: 'aCookable');
		 connectionBuilderAt: 3
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'AddRecipe');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 actionName: #addNew);
		 connectionBuilderAt: 5
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 actionName: #edit:);
		 connectionBuilderAt: 6
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RecipesList');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 5);
				 targetAttributeName: 'aRecipe');
		 connectionBuilderAt: 7
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RecipesList');
				 sourceAttributeName: #selectionIsValid;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 targetAttributeName: #enabled);
		 connectionBuilderAt: 11
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 12
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 22
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'RecipesList');
				 sourceAttributeName: #items;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 targetAttributeName: #contained);
		 connectionBuilderAt: 23
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aRecipeManager);
		 connectionBuilderAt: 14
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse);
		 connectionBuilderAt: 15
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnTrue);
		 connectionBuilderAt: 16
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #openedWidget;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse).

	^aTopLevelPartBuilder!

test
	" Test creating the view. "
	" RecipeManagerView recalculatePartBuilderRecordFromArchivalCode.  "
	" RecipeManagerView test  "

	RecipeManagerView newInShellView openWidget.! !


!RecipeView class publicMethods !

calculatePartBuilder
	"Create the edit time part tree for the RecipeView."
	" RecipeView recalculatePartBuilderRecordFromArchivalCode. "

	| aRecipeView |

	aRecipeView := self newTopLevelPartBuilder.

	aRecipeView
		 subpartBuilderNamed: 'Window'
			 put: (self addWindowPartBuilder: aRecipeView);
		 subpartBuilderNamed: 'aRecipe'
			 put: ((Recipe) newVariableBuilder);
		 subpartBuilderNamed: 'Ingredient Manager Var'
			 put: ((IngredientManager) newVariableBuilder);
		 subpartBuilderNamed: 'Recipe Manager Var'
			 put: ((RecipeManager) newVariableBuilder).

	aRecipeView
		 attributeSettingNamed: #primaryPart put: (aRecipeView subpartBuilderNamed: 'Window').

	self connectRecipeView: aRecipeView.

	^aRecipeView! !

!RecipeView class privateMethods !

addDescriptionFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterPartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 189);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 28);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 20)).

	^anAbtTextView!

addDescriptionLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #description;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 40);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 85);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 30);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 16)).

	^anAbtLabelView!

addLabel1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Ingredients';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 15);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 134);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel21PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Recipes:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 217);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 229);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'Ingredients:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 218);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 132);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_weight';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 100);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 321);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total weight:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 15);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 321);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel51PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total time:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 202);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 336);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel5PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'total price:';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 25);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 338);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel61PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_time';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 277);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 336);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addLabel6PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: 'tot_price';
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 100);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 338);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtLabelView!

addList1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 10);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 154);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 159);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 157)).

	^anAbtListView!

addList21PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 214);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 154);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 256);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 63)).

	^anAbtListView!

addList2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtListView."

	| anAbtListView |

	anAbtListView := AbtListView newSubpartBuilder.

	anAbtListView
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 215);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 154);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 159);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 63)).

	^anAbtListView!

addNameFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate2PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 189);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 4);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 20)).

	^anAbtTextView!

addNameLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #name;
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 40);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 85);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 7);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 16)).

	^anAbtLabelView!

addPushButton1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'OK';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 228);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 73);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 373);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 25)).

	^anAbtPushButtonView!

addPushButton2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Cancel';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 76);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 73);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 373);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 25)).

	^anAbtPushButtonView!

addPushButton31PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Manage';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 307);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 226);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: 'Manage';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 308);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 129);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: '<<';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 176);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 171);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton5PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: '>>';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 177);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 224);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addPushButton6PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtPushButtonView."

	| anAbtPushButtonView |

	anAbtPushButtonView := AbtPushButtonView newSubpartBuilder.

	anAbtPushButtonView
		 attributeSettingNamed: #object put: '<<';
		 attributeSettingNamed: #accelerator put: nil;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 175);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 274);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE)).

	^anAbtPushButtonView!

addSalePriceField1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate5PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 189);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 168);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 76);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 20)).

	^anAbtTextView!

addSalePriceFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #converter put: (self converterDuplicate3PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 189);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 52);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 20)).

	^anAbtTextView!

addSalePriceLabel1PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #'additional weight:';
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 40);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 144);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 76);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 17)).

	^anAbtLabelView!

addSalePriceLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #'additional price:';
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 40);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 137);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 53);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 17)).

	^anAbtLabelView!

addTimeFieldPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtTextView."

	| anAbtTextView |

	anAbtTextView := AbtTextView newSubpartBuilder.

	anAbtTextView
		 attributeSettingNamed: #object put: nil;
		 attributeSettingNamed: #converter put: (self converterDuplicate4PartBuilder: anAbtTextView);
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 189);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHNONE);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 100);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 20)).

	^anAbtTextView!

addTimeLabelPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtLabelView."

	| anAbtLabelView |

	anAbtLabelView := AbtLabelView newSubpartBuilder.

	anAbtLabelView
		 attributeSettingNamed: #object put: #'cooking time:';
		 attributeSettingNamed: #alignment put: 0;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 40);
			rightEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 85);
			topEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHFORM;
				offset: 99);
			bottomEdge: (AbtEditEdgeAttachmentSpec new
				attachment: XmATTACHSELFOPPOSITE;
				offset: 16)).

	^anAbtLabelView!

addWindowPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtShellView."

	| anAbtShellView |

	anAbtShellView := AbtShellView newSubpartBuilder.

	anAbtShellView
		 subpartBuilderNamed: 'descriptionLabel'
			 put: (self addDescriptionLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'descriptionField'
			 put: (self addDescriptionFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'nameLabel'
			 put: (self addNameLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'nameField'
			 put: (self addNameFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'salePriceLabel'
			 put: (self addSalePriceLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'salePriceField'
			 put: (self addSalePriceFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'timeLabel'
			 put: (self addTimeLabelPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'timeField'
			 put: (self addTimeFieldPartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label1'
			 put: (self addLabel1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List1'
			 put: (self addList1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button1'
			 put: (self addPushButton1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button2'
			 put: (self addPushButton2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List2'
			 put: (self addList2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label2'
			 put: (self addLabel2PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button3'
			 put: (self addPushButton3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button4'
			 put: (self addPushButton4PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'List21'
			 put: (self addList21PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label21'
			 put: (self addLabel21PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button31'
			 put: (self addPushButton31PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button5'
			 put: (self addPushButton5PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Push Button6'
			 put: (self addPushButton6PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'salePriceLabel1'
			 put: (self addSalePriceLabel1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'salePriceField1'
			 put: (self addSalePriceField1PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label3'
			 put: (self addLabel3PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label4'
			 put: (self addLabel4PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label5'
			 put: (self addLabel5PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label6'
			 put: (self addLabel6PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label51'
			 put: (self addLabel51PartBuilder: anAbtShellView);
		 subpartBuilderNamed: 'Label61'
			 put: (self addLabel61PartBuilder: anAbtShellView).

	anAbtShellView
		 attributeSettingNamed: #shellDecorations put: 122;
		 attributeSettingNamed: #framingSpec put: (AbtViewAttachmentSpec new
			leftEdge: (AbtEdgeConstant new
				offset: 115);
			rightEdge: (AbtEdgeConstant new
				offset: 377);
			topEdge: (AbtEdgeConstant new
				offset: 7);
			bottomEdge: (AbtEdgeConstant new
				offset: 403));
		 attributeSettingNamed: #title put: 'Recipe'.

	^anAbtShellView!

calculateInterfaceSpec
	"Create the interface specification for the RecipeView."
	" RecipeView reinitializeInterfaceSpecFromMethod. "

	^AbtInterfaceSpecBuilder new
		featureBuilderNamed: #aRecipe put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Recipe;
			attributeSettingNamed: #setSelector put: #aRecipe:;
			attributeSettingNamed: #getSelector put: #aRecipe;
			attributeSettingNamed: #changeSymbol put: #aRecipe);
		featureBuilderNamed: #aIngredientManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #IngredientManager;
			attributeSettingNamed: #setSelector put: #aIngredientManager:;
			attributeSettingNamed: #getSelector put: #aIngredientManager;
			attributeSettingNamed: #changeSymbol put: #aIngredientManager);
		featureBuilderNamed: #aRecipeManager put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #RecipeManager;
			attributeSettingNamed: #setSelector put: #aRecipeManager:;
			attributeSettingNamed: #getSelector put: #aRecipeManager;
			attributeSettingNamed: #changeSymbol put: #aRecipeManager);
		featureBuilderNamed: #Result put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Boolean;
			attributeSettingNamed: #setSelector put: #result:;
			attributeSettingNamed: #getSelector put: #result;
			attributeSettingNamed: #changeSymbol put: #Result);
		featureBuilderNamed: #returnTrue put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnTrue);
		featureBuilderNamed: #returnFalse put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #returnFalse);
		featureBuilderNamed: #TotalWeight put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalWeight:;
			attributeSettingNamed: #getSelector put: #totalWeight;
			attributeSettingNamed: #changeSymbol put: #TotalWeight);
		featureBuilderNamed: #recalculateWeight put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculateWeight);
		featureBuilderNamed: #TotalPrice put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalPrice:;
			attributeSettingNamed: #getSelector put: #totalPrice;
			attributeSettingNamed: #changeSymbol put: #TotalPrice);
		featureBuilderNamed: #recalculatePrice put: (AbtActionSpec newFeatureBuilder
			attributeSettingNamed: #parameters put: (OrderedCollection new
				 yourself);
			attributeSettingNamed: #selector put: #recalculatePrice);
		featureBuilderNamed: #TotalTime put: (AbtAttributeSpec newFeatureBuilder
			attributeSettingNamed: #attributeClass put: #Number;
			attributeSettingNamed: #setSelector put: #totalTime:;
			attributeSettingNamed: #getSelector put: #totalTime;
			attributeSettingNamed: #changeSymbol put: #TotalTime)!

codeGenerationParameters: builder
	^IdentityDictionary new
		yourself!

connectRecipeView: aTopLevelPartBuilder
	"Create the edit time part tree for the RecipeView."

	aTopLevelPartBuilder
		 connectionBuilderAt: 2
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 12
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #ingredients;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 targetAttributeName: #items);
		 connectionBuilderAt: 6
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aRecipe);
		 connectionBuilderAt: 10
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #closeWidget);
		 connectionBuilderAt: 11
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button4');
				 sourceAttributeName: #enabled;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 targetAttributeName: #selectionIsValid);
		 connectionBuilderAt: 22
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 sourceAttributeName: #contained;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 targetAttributeName: #items);
		 connectionBuilderAt: 13
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button3');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 actionName: #manage);
		 connectionBuilderAt: 14
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Ingredient Manager Var');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aIngredientManager);
		 connectionBuilderAt: 15
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button4');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 actionName: #add:);
		 connectionBuilderAt: 16
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List2');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 15);
				 targetAttributeName: 'aIngredient');
		 connectionBuilderAt: 17
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button5');
				 sourceAttributeName: #enabled;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 targetAttributeName: #selectionIsValid);
		 connectionBuilderAt: 18
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button6');
				 sourceAttributeName: #enabled;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List21');
				 targetAttributeName: #selectionIsValid);
		 connectionBuilderAt: 19
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 sourceAttributeName: #self;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #aRecipeManager);
		 connectionBuilderAt: 20
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 sourceAttributeName: #contained;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List21');
				 targetAttributeName: #items);
		 connectionBuilderAt: 21
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button31');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Recipe Manager Var');
				 actionName: #manage);
		 connectionBuilderAt: 32
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button6');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 actionName: #add:);
		 connectionBuilderAt: 23
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List21');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 32);
				 targetAttributeName: 'aIngredient');
		 connectionBuilderAt: 24
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button5');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 actionName: #remove:);
		 connectionBuilderAt: 25
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'List1');
				 sourceAttributeName: #selectedItem;
				 targetBuilder: (aTopLevelPartBuilder connectionBuilderNamed: 24);
				 targetAttributeName: 'aIngredient');
		 connectionBuilderAt: 26
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button1');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnTrue);
		 connectionBuilderAt: 27
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Push Button2');
				 eventName: #clicked;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse);
		 connectionBuilderAt: 28
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Window');
				 eventName: #openedWidget;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #returnFalse);
		 connectionBuilderAt: 35
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #name;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'nameField');
				 targetAttributeName: #object);
		 connectionBuilderAt: 36
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #description;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'descriptionField');
				 targetAttributeName: #object);
		 connectionBuilderAt: 37
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #salePrice;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'salePriceField');
				 targetAttributeName: #object);
		 connectionBuilderAt: 38
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 sourceAttributeName: #time;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'timeField');
				 targetAttributeName: #object);
		 connectionBuilderAt: 47
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'salePriceField1');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'aRecipe');
				 targetAttributeName: #saleWeight);
		 connectionBuilderAt: 58
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'salePriceField1');
				 eventName: #losingFocus;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #recalculateWeight);
		 connectionBuilderAt: 48
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label3');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #TotalWeight);
		 connectionBuilderAt: 29
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label6');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #TotalPrice);
		 connectionBuilderAt: 30
			 put: (AbtEventToActionConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'salePriceField');
				 eventName: #object;
				 targetBuilder: (aTopLevelPartBuilder);
				 actionName: #recalculatePrice);
		 connectionBuilderAt: 31
			 put: (AbtAttributeToAttributeConnectionBuilder new 
				 sourceBuilder: (aTopLevelPartBuilder subpartBuilderNamed: 'Label61');
				 sourceAttributeName: #object;
				 targetBuilder: (aTopLevelPartBuilder);
				 targetAttributeName: #TotalTime).

	^aTopLevelPartBuilder!

converterDuplicate2PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtStringConverter."

	| anAbtStringConverter |

	anAbtStringConverter := AbtStringConverter newTopLevelPartBuilder.

	^anAbtStringConverter!

converterDuplicate3PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtDecimalConverter."

	| anAbtDecimalConverter |

	anAbtDecimalConverter := AbtDecimalConverter newTopLevelPartBuilder.

	^anAbtDecimalConverter!

converterDuplicate4PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtNumberConverter."

	| anAbtNumberConverter |

	anAbtNumberConverter := AbtNumberConverter newTopLevelPartBuilder.

	^anAbtNumberConverter!

converterDuplicate5PartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtDecimalConverter."

	| anAbtDecimalConverter |

	anAbtDecimalConverter := AbtDecimalConverter newTopLevelPartBuilder.

	^anAbtDecimalConverter!

converterPartBuilder: aParentPartBuilder
	"Create the edit time part tree for the AbtStringConverter."

	| anAbtStringConverter |

	anAbtStringConverter := AbtStringConverter newTopLevelPartBuilder.

	^anAbtStringConverter!

test
	" Test creating the view. "
	" RecipeView recalculatePartBuilderRecordFromArchivalCode.  "
	" RecipeView test  "

	RecipeView newInShellView openWidget.! !


MerlinArchive initializeAfterLoad!

MerlinArchive loaded!