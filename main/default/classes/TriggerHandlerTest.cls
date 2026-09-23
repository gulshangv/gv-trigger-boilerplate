/**
 * Tests for Trigger Handler Framework
 * 
 * Adapted version of https://github.com/kevinohara80/sfdc-trigger-framework
 * 
 * @date    2018-03-09
 * @author  Kevin M. O'Hara
 */
@isTest
private class TriggerHandlerTest {

    /**
     * Variable used by the TestHandler to deterime which method was
     * executed.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara
     * @return    String - Name of last called test handler method
     */
    private static String lastMethodCalled;

    /**
     * @method     beforeInsert
     * @case       Test beforeInsert method is overridable and called by
     *             the handler.
     * @result     beforeInsert is called.
     */
    @isTest static void triggerHandler_beforeInsert() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isBefore = true;
        handler.isInsert = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }
    
    /**
     * @method     beforeUpdate
     * @case       Test beforeUpdate method is overridable and called by
     *             the handler.
     * @result     beforeUpdate is called.
     */
    @isTest static void triggerHandler_beforeUpdate() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isBefore = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        handler.run();
        Test.stopTest();
        
        System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
    }

    /**
     * @method     beforeDelete
     * @case       Test beforeDelete method is overridable and called by
     *             the handler.
     * @result     beforeDelete is called.
     */
    @isTest static void triggerHandler_beforeDelete() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isBefore = true;
        handler.isDelete = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
    }
    
    /**
     * @method     afterInsert
     * @case       Test afterInsert method is overridable and called by
     *             the handler.
     * @result     afterInsert is called.
     */
    @isTest static void triggerHandler_afterInsert() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isAfter = true;
        handler.isInsert = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
    }

    /**
     * @method     afterUpdate
     * @case       Test afterUpdate method is overridable and called by
     *             the handler.
     * @result     afterUpdate is called.
     */
    @isTest static void triggerHandler_afterUpdate() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isAfter = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        handler.run();
        Test.stopTest();
        
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
    }

    /**
     * @method     afterDelete
     * @case       Test afterDelete method is overridable and called by
     *             the handler.
     * @result     afterDelete is called.
     */
    @isTest static void triggerHandler_afterDelete() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isAfter = true;
        handler.isDelete = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
    }

    /**
     * @method     afterUndelete
     * @case       Test afterUndelete method is overridable and called by
     *             the handler.
     * @result     afterUndelete is called.
     */
    @isTest static void triggerHandler_afterUndelete() {

        Test.startTest();
        TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
        handler.isAfter = true;
        handler.isUndelete = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
    }
    
    /**
     * @method     beforeInsert, beforeUpdate, beforeDelete, 
     *             afterInsert, afterUpdate, afterDelete & afterUndelete
     * @case       Test virtual methods can be called without error
     * @result     Methods can be called. Nothing to test as the methods
     *             don't do anything until overridden.
     */
    @isTest static void triggerHandler_virtualMethods() {
        TriggerHandler handler = new TriggerHandler();
        handler.beforeInsert();
        handler.beforeUpdate();
        handler.beforeDelete();
        handler.afterInsert();
        handler.afterUpdate();
        handler.afterDelete();
        handler.afterUndelete();
    }
    
    /**
     * @method     debugVariables
     * @case       Test debugVariables method is called when debugVariables
     *             is true. No way to verify method.
     * @result     No errors are generated.
     */
    @isTest static void triggerHandler_debugVariables() {

        Test.startTest();
        
        TriggerHandler.debugVariables = true;

        TestHandler handler = new TestHandler();
        handler.isBefore = true;
        handler.isInsert = true;
        handler.run();
        Test.stopTest();
        
        System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }

    /**
     * @method     validateRun
     * @case       Test exception is thrown when no context is specified.
     * @result     TriggerHandlerException thrown.
     */
    @isTest static void triggerHandler_noContext() {

        Test.startTest();
        try {
            new TestHandler().run();
            System.assert(false, 'the handler ran but should have thrown');
        } catch (TriggerHandler.TriggerHandlerException ex) {
            System.assertEquals(
                'Failed to determine trigger context!', 
                ex.getMessage(), 
                'the exception message should match'
            );
        } catch (Exception ex) {
            System.assert(false, 'the exception thrown was not expected: ' + ex.getTypeName() + ': ' + ex.getMessage());
        }
        Test.stopTest();
    }
    
    /**
     * @method     bypass, clearBypass, isBypassed & clearAllBypasses
     * @case       1) Trigger handler can be bypassed using bypass method
     *             2) Trigger handler bypass can be cleared
     *             3) isBypassed returns bypass status
     *             4) All trigger handler bypasses can be cleared
     * @result     1) Trigger handler doesn't run after bypass
     *             2) Trigger handler does run after clear
     *             3) Correct bypass status is returned
     *             4) Trigger handler does run after clear all bypasses
     */
    @isTest static void triggerHandler_bypass_method() {

        Test.startTest();
        
        TestHandler handler = new TestHandler();
        handler.isAfter = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        
        TriggerHandler.bypass('TestHandler');
        
        // Run with bypass
        handler.run();
        
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assert(TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        resetTest();
        
        TriggerHandler.clearBypass('TestHandler');
        
        // Run without bypass (after clear)
        handler.run();
        
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assert(!TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        resetTest();
        
        TriggerHandler.bypass('TestHandler');
        
        // Run with bypass
        handler.run();
        
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assert(TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        resetTest();
        
        TriggerHandler.clearAllBypasses();
        
        // Run without bypass (after clear all)
        handler.run();
        
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assert(!TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        Test.stopTest();
    }
    
    /**
     * @method     bypass, clearBypass, isBypassed & clearAllBypasses
     * @case       1) Trigger handler can be bypassed using bypass custom setting
     *             2) Trigger handler bypass can be cleared
     * @result     1) Trigger handler doesn't run after bypass
     *             2) Trigger handler does run after clear
     */
    @isTest static void triggerHandler_bypass_customSettingIndividual() {

        ProcessDeactivationDataFactory processDeactivationFactory = new ProcessDeactivationDataFactory();
        
        Process_Deactivation__c processDeactivationSetting = (Process_Deactivation__c) processDeactivationFactory.build();
        processDeactivationSetting.Disable_Triggers__c = 'Test1,TestHandler,Test2';
        
        processDeactivationFactory.create(processDeactivationSetting);
        
        Test.startTest();
        TestHandler handler = new TestHandler();
        handler.isAfter = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        
        // Run with custom setting bypass
        handler.run();
        
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assert(TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        resetTest();
        
        TriggerHandler.clearBypass('TestHandler');
        
        // Run without bypass (after clear)
        handler.run();
        
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assert(!TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        
        Test.stopTest();
    }
    
    /**
     * @method     validateRun
     * @case       Trigger handler can be bypassed using disable all custom setting.
     * @result     Trigger handler doesn't run with custom setting present.
     */
    @isTest static void triggerHandler_bypass_customSettingAll() {

        ProcessDeactivationDataFactory processDeactivationFactory = new ProcessDeactivationDataFactory();
        
        Process_Deactivation__c processDeactivationSetting = (Process_Deactivation__c) processDeactivationFactory.build();
        processDeactivationSetting.Disable_All_Triggers__c = true;
        
        processDeactivationFactory.create(processDeactivationSetting);
        
        Test.startTest();   

        TestHandler handler = new TestHandler();
        handler.isAfter = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        
        handler.run();
        
        Test.stopTest();

        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    }

    /**
     * @method     validateRun
     * @case       Trigger handler can be bypassed using bypassAllHandlers static variable.
     * @result     Trigger handler doesn't run with variable set.
     */
    @isTest static void triggerHandler_bypass_variableAll() {

        Test.startTest();  
        TriggerHandler.bypassAllHandlers = true;

        TestHandler handler = new TestHandler();
        handler.isAfter = true;
        handler.isUpdate = true;
        setupChangedRecords( handler );
        
        handler.run();
        
        Test.stopTest();

        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    }
    
    /**
     * @method     setMaxLoopCount & clearMaxLoopCount
     * @case       1) Trigger handler can be called up to limit
     *             2) Trigger handler throws exception on exceeding limit
     *             3) Trigger handler limit can be cleared
     * @result     1) Trigger handler runs up to limit
     *             2) Trigger handler throws exception
     *             3) Trigger handler continues to run after clearing limit
     */
    @isTest static void triggerHandler_loopCount() {

        Test.startTest();        
        TestHandler handler = new TestHandler();
        handler.isBefore = true;
        handler.isInsert = true;      

        // Set limit to 2
        handler.setMaxLoopCount(2);
        
        // Run twice
        handler.run();
        handler.run();
        
        // Clear last method variable
        resetTest();

        try {
            // Try running again. This should exceed the limit.
            handler.run();
            System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
        } catch (TriggerHandler.TriggerHandlerException te) {
            // We're expecting to get here
            System.assertEquals(null, lastMethodCalled, 'last method should be null');
        } catch (Exception e) {  
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }

        // Clear the last method variable
        resetTest();

        // Clear the loop count
        handler.clearMaxLoopCount();

        try {
            // Re-run the handler. We shouldn't throw now.
            handler.run();
            System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
        } catch (TriggerHandler.TriggerHandlerException te) {
            System.assert(false, 'running the handler after clearing the loop count should not throw');
        } catch (Exception e) {  
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    /**
     * @method     handlerName
     * @case       Trigger handler name is set correctly.
     * @result     Trigger handler name is returned.
     */
    @isTest static void triggerHandler_handlerName() {

        Test.startTest();
        TestHandler handler = new TestHandler();
        System.assertEquals('TestHandler', handler.handlerName, 'handler name should match class name');
        Test.stopTest();
    }

    /**
     * @method     beforeUpdate
     * @case       When no objects are listed
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_beforeUpdate_isNotCalledIfNoObjectsAreListed() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isBefore = true;
            handler.isUpdate = true;
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'beforeUpdate overridden method is not called if no records are listed' );
    }

    /**
     * @method     beforeUpdate
     * @case       When no objects have changed
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_beforeUpdate_isNotCalledIfNoObjectsHaveChanged() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isBefore = true;
            handler.isUpdate = true;
            setupUnchangedRecords( handler );

            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'beforeUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     beforeUpdate
     * @case       When the changed fields are defined as object specific benign fields, and the fields are defined in camel case
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_beforeUpdate_isNotCalledIfOnlyBenignFieldsHaveChanged_benignFieldsDefinedInCamelCase() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isBefore = true;
            handler.isUpdate = true;

            setupChangedRecords( handler );

            handler.objectSpecificBenignFields = new Set<String>{ 'FirstName' };
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'beforeUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     beforeUpdate
     * @case       When the changed fields are defined as object specific benign fields, and the fields are defined in lower case
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_beforeUpdate_isNotCalledIfOnlyBenignFieldsHaveChanged_benignFieldsDefinedInlowerCase() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isBefore = true;
            handler.isUpdate = true;

            setupChangedRecords( handler );

            handler.objectSpecificBenignFields = new Set<String>{ 'firstname' };
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'beforeUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     afterUpdate
     * @case       When no objects are listed
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_afterUpdate_isNotCalledIfNoObjectsAreListed() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isAfter  = true;
            handler.isUpdate = true;
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'afterUpdate overridden method is not called if no records are listed' );
    }

    /**
     * @method     afterUpdate
     * @case       When no objects have changed
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_afterUpdate_isNotCalledIfNoObjectsHaveChanged() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isAfter  = true;
            handler.isUpdate = true;
            setupUnchangedRecords( handler );

            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'afterUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     afterUpdate
     * @case       When the changed fields are defined as object specific benign fields, and the fields are defined in camel case
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_afterUpdate_isNotCalledIfOnlyBenignFieldsHaveChanged_benignFieldsDefinedInCamelCase() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isAfter  = true;
            handler.isUpdate = true;

            setupChangedRecords( handler );

            handler.objectSpecificBenignFields = new Set<String>{ 'FirstName' };
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'afterUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     afterUpdate
     * @case       When the changed fields are defined as object specific benign fields, and the fields are defined in lower case
     * @result     will not call the overridden method
     */
    @isTest static void triggerHandler_afterUpdate_isNotCalledIfOnlyBenignFieldsHaveChanged_benignFieldsDefinedInlowerCase() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isAfter  = true;
            handler.isUpdate = true;

            setupChangedRecords( handler );

            handler.objectSpecificBenignFields = new Set<String>{ 'firstname' };
            handler.run();
        Test.stopTest();
        
        System.assertEquals( null, lastMethodCalled, 'afterUpdate overridden method is not called if no records have changed' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that is set and has not changed
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsSetAndHasNotChanged_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'LastName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on update, given a field that is set and has not changed, returns false' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that is set and has changed, passed in lowercase, returns false
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsSetAndHasChanged_LowerCase_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'firstname' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on update, given a field that is set and has changed, defined in lowercase, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that is set and has changed, passed in CamelCase, returns false
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsSetAndHasChanged_CamelCase_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on update, given a field that is set and has changed, defined in CamelCase, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that has changed from null to Set
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsChangedFromNullToSet_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler, null, 'newvalue' );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on update, given a field that is set and has changed from null to set, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that has changed from set to null
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsChangedFromSetToNull_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler, 'newvalue', null );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on update, given a field that is set and has changed from set to null, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that is not set nd has not changed
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatHasNotChangedAndIsNull_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler, null, null );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on update, given a field that is not set and has not changed, returns false' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given a field that is invalid, returns false
     * @result     raises an exception
     */
    @isTest static void fieldHasChanged_onUpdate_givenAFieldThatIsInvalid_raisesAnException() {

        Boolean exceptionThrown = false;

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            try {
                Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'InvalidField' );
            } catch ( Exception e ) {
                exceptionThrown = true;
            }
        Test.stopTest();
        
        System.assertEquals( true, exceptionThrown, 'fieldHasChanged, on update, given a field that is invalid, throws an exception' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on update, given an Id invalid, returns false
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onUpdate_givenAnIdThatIsInvalid_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isUpdate = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );
            Id idOfRecordNotInTrigger   = TestUtils.generateId( 'Account' );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordNotInTrigger, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on update, given an Id that is invalid, returns false' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on delete, given a record in the old map
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onDelete_givenAnIdThatIsInTheOldMap_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isDelete = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on delete, given an Id that is in the old map, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on delete, given a record that is not in the old map
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onDelete_givenAnIdThatIsNotInTheOldMap_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isDelete = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );
            Id idOfRecordNotInTrigger   = TestUtils.generateId( 'Account' );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordNotInTrigger, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on delete, given an Id that is NOT in the old map, returns false' );
    }

   /**
     * @method     fieldHasChanged
     * @case       on insert, given a field that is set
     * @result     returns true
     */
    @isTest static void fieldHasChanged_onInsert_givenAFieldThatIsSet_returnsTrue() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isInsert = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( true, fieldHasChanged, 'fieldHasChanged, on insert, given a field that is set, returns true' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on insert, given a field that is not set
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onInsert_givenAFieldThatIsNotSet_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isInsert = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler, 'notused', 'notused' );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'LastName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on insert, given a field that is not set, returns false' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on insert, given a field that is set to null
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onInsert_givenAFieldThatIsSetToNull_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isInsert = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler, null, null );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'FirstName' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on insert, given a field that is not set, returns false' );
    }

    /**
     * @method     fieldHasChanged
     * @case       on insert, given a field that is invalid
     * @result     returns false
     */
    @isTest static void fieldHasChanged_onInsert_givenAFieldThatIsInvalid_returnsFalse() {

        Test.startTest();
            TriggerHandlerTest.TestHandler handler = new TriggerHandlerTest.TestHandler();
            handler.isInsert = true;

            Id idOfRecordThatHasChanged = setupChangedRecords( handler );

            Boolean fieldHasChanged = handler.fieldHasChanged( idOfRecordThatHasChanged, 'InvalidField' );
        Test.stopTest();
        
        System.assertEquals( false, fieldHasChanged, 'fieldHasChanged, on insert, given a field that is invalid, returns false' );
    }

    /**
     * Helper method to reset the last called method.
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara
     */
    private static void resetTest() {
        lastMethodCalled = null;
    }

    /**
     * Helper method to setup the trigger handler so it contains a changed record - ensures that
     * the update trigger context is correct
     * 
     * @date    2019-06-24
     * @author  makepositive
     */
    private static Id setupChangedRecords( TriggerHandler triggerHandler ) {

        Id contactId = TestUtils.generateId( 'Contact' );
        Contact originalContact = new Contact( Id = contactId, FirstName = 'unchanged', LastName = 'unchanged' );
        Contact changedContact  = new Contact( Id = contactId, FirstName = 'changed'  , LastName = 'unchanged' );

        triggerHandler.newList = new List<SObject>{ changedContact };
        triggerHandler.newMap  = new Map<Id,SObject>{ contactId => changedContact };
        triggerHandler.oldMap  = new Map<Id,SObject>{ contactId => originalContact };

        return contactId;
    }

    /**
     * Helper method to setup the trigger handler so it contains a changed record - ensures that
     * the update trigger context is correct
     * 
     * @date    2019-06-24
     * @author  makepositive
     */
    private static Id setupChangedRecords( TriggerHandler triggerHandler, String fromValue, String toValue ) {

        Id contactId = TestUtils.generateId( 'Contact' );
        Contact originalContact = new Contact( Id = contactId, FirstName = fromValue );
        Contact changedContact  = new Contact( Id = contactId, FirstName = toValue   );

        triggerHandler.newList = new List<SObject>{ changedContact };
        triggerHandler.newMap  = new Map<Id,SObject>{ contactId => changedContact };
        triggerHandler.oldMap  = new Map<Id,SObject>{ contactId => originalContact };

        return contactId;
    }

    /**
     * Helper method to setup the trigger handler so it contains an unchaged record
     * 
     * @date    2019-06-24
     * @author  makepositive
     */
    private static void setupUnchangedRecords( TriggerHandler triggerHandler ) {

        Id contactId = TestUtils.generateId( 'Contact' );
        Contact originalContact = new Contact( Id = contactId, FirstName = 'unchanged' );
        Contact changedContact  = new Contact( Id = contactId, FirstName = 'unchanged'   );

        triggerHandler.newList = new List<SObject>{ changedContact };
        triggerHandler.newMap  = new Map<Id,SObject>{ contactId => changedContact };
        triggerHandler.oldMap  = new Map<Id,SObject>{ contactId => originalContact };
    }

    /**
     * Test implementation of the TriggerHandler
     * 
     * @date    2018-03-09
     * @author  Kevin M. O'Hara
     */
    private class TestHandler extends TriggerHandler {
        
        public Set<String> objectSpecificBenignFields = new Set<String>();

        /**
         * Override beforeInsert method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void beforeInsert() {
            TriggerHandlerTest.lastMethodCalled = 'beforeInsert';
        }
        
        /**
         * Override beforeUpdate method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void  beforeUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
        }
        
        /**
         * Override beforeDelete method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void beforeDelete() {
            TriggerHandlerTest.lastMethodCalled = 'beforeDelete';
        }
        
        /**
         * Override afterInsert method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void afterInsert() {
            TriggerHandlerTest.lastMethodCalled = 'afterInsert';
        }
        
        /**
         * Override afterUpdate method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void afterUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'afterUpdate';
        }

        /**
         * Override afterDelete method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void afterDelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterDelete';
        }

        /**
         * Override afterUndelete method.
         * 
         * @date    2018-03-09
         * @author  Kevin M. O'Hara
         */
        public override void afterUndelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterUndelete';
        }

        /**
         * Override getObjectSpecificBenignFields method.
         * 
         * @date    2019-06-24
         * @author  makepositive
         */
        public override Set<String> getObjectSpecificBenignFields() {
            return objectSpecificBenignFields;
        }
    }
}