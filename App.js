import React from 'react';
import {Button, SafeAreaView, NativeModules, View} from 'react-native';

const {TimerWidgetModule} = NativeModules;

const CONSUMER_ID = '12123-1212313-13133';

function App() {
  //Swift listerner for push token of activity when made using a push notification
  TimerWidgetModule.observeActivityPushToken();
  //Swift listener for push to start token
  TimerWidgetModule.observePushToStartToken(CONSUMER_ID);

  return (
    <SafeAreaView style={{flex: 1, justifyContent: 'center'}}>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          paddingHorizontal: 48,
        }}>
        <Button
          title="Get Token"
          onPress={() => {
            //Manually get push to start token
            TimerWidgetModule.getPushToStartToken(CONSUMER_ID);
          }}
        />
        <Button
          title="Start Activity"
          onPress={() => {
            TimerWidgetModule.startLiveActivity();
          }}
        />
        <Button
          title="Stop Activity"
          onPress={() => {
            TimerWidgetModule.stopLiveActivity();
          }}
        />
      </View>
    </SafeAreaView>
  );
}

export default App;
