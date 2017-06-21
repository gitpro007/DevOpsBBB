package org.bigbluebutton.modules.users.views
{
  import mx.collections.ArrayCollection;
  
  import org.bigbluebutton.core.UsersUtil;
  import org.bigbluebutton.core.model.LiveMeeting;
  import org.bigbluebutton.core.model.users.User2x;
  import org.bigbluebutton.core.model.users.VoiceUser2x;
  import org.bigbluebutton.main.events.UserJoinedEvent;
  import org.bigbluebutton.modules.users.views.model.BBBUser2x;
  import org.bigbluebutton.modules.users.views.model.BBBVoiceUser2x;
  
  public class UsersWindowEventHandler
  {

    private function removeUser(userId:String, users: ArrayCollection):void {
      for (var i:int = 0; i < users.length; i++) {
        var user:BBBUser2x = users.getItemAt(i) as BBBUser2x;
        if (user.userId == userId) {
          users.removeItemAt(i);
          users.refresh();
          return;
        }
      }
    }
        
    public function getAllUser(users: ArrayCollection):void {
      var userIds: Array = LiveMeeting.inst().users.getUserIds();
      
      for (var i:int = 0; i < userIds.length; i++) {
        var userId: String = userIds[i] as String;
        addUser(users, userId);
      }
      
      users.refresh();
    }
    
    private function addUser(users: ArrayCollection, userId: String):void {
      var user: User2x = UsersUtil.getUser2x(userId);
      var voiceUser: VoiceUser2x = LiveMeeting.inst().voiceUsers.getUser(userId);
      
      var buser: BBBUser2x = new BBBUser2x();
      buser.me = (LiveMeeting.inst().me.id == user.intId);
      buser.userId = user.intId;
      buser.name = user.name;
      buser.role = user.role;
      buser.guest = user.guest;
      buser.locked = user.locked;
      buser.emojiStatus = user.emoji;
      buser.presenter = user.presenter;
      
      buser.inVoiceConf = false;
      if (voiceUser != null) {
        buser.inVoiceConf = true;
        buser.muted = voiceUser.muted;
        buser.callingWith = voiceUser.callingWith;
        buser.talking = voiceUser.talking;
        buser.listenOnly = voiceUser.listenOnly;
      }
      
      // We want to remove the user if it's already in the collection and re-add it.
      removeUser(userId, users);
      
      users.addItem(buser);
    }
    
    public function handleUserJoinedEvent(event: UserJoinedEvent, users: ArrayCollection):void {
      addUser(users, event.userID);
      users.refresh();
    }
    
    
    private function removeVoiceUser(userId:String, voiceUsers: ArrayCollection):void {
      for (var i:int = 0; i < voiceUsers.length; i++) {
        var user:BBBVoiceUser2x = voiceUsers.getItemAt(i) as BBBVoiceUser2x;
        if (user.userId == userId) {
          voiceUsers.removeItemAt(i);
          voiceUsers.refresh();
          return;
        }
      }
    }
    
    public function getAllVoiceUsers(voiceUsers: ArrayCollection):void {
      var voiceOnlyUsers: Array = LiveMeeting.inst().voiceUsers.getVoiceOnlyUsers();
      
      for (var i:int = 0; i < voiceOnlyUsers.length; i++) {
        var user:VoiceUser2x = voiceOnlyUsers[i] as VoiceUser2x;
        var vUser: BBBVoiceUser2x = new BBBVoiceUser2x();
        vUser.userId = user.intId;
        vUser.callingWith = user.callingWith;
        vUser.name = user.callerName;
        vUser.muted = user.muted;
        vUser.talking = user.talking;
        vUser.listenOnly = user.listenOnly;
        
        removeVoiceUser(user.intId, voiceUsers);
        voiceUsers.addItem(vUser);
      }
      
      voiceUsers.refresh();

    }
  }
}