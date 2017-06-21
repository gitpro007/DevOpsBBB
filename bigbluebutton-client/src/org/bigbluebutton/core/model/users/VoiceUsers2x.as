package org.bigbluebutton.core.model.users
{
  import mx.collections.ArrayCollection;
  
  import org.bigbluebutton.core.model.LiveMeeting;
  
  public class VoiceUsers2x
  {
    
    private var _users:ArrayCollection = new ArrayCollection();
    
    public function add(user: VoiceUser2x):void {
      _users.addItem(user);
    }
    
    public function remove(userId: String):VoiceUser2x {
      var index:int = getIndex(userId);
      if (index >= 0) {
        return _users.removeItemAt(index) as VoiceUser2x;
      }
      
      return null;
    }
    
    public function getUserAndIndex(userId: String):Object {
      var user:VoiceUser2x;
      for (var i:int = 0; i < _users.length; i++) {
        user = _users.getItemAt(i) as VoiceUser2x;
        
        if (user.intId == userId) {
          return {index:i, user:user};;
        }
      }
      
      return null;      
    }
    
    public function getUser(userId:String):VoiceUser2x {
      var user:VoiceUser2x;
      
      for (var i:int = 0; i < _users.length; i++) {
        user = _users.getItemAt(i) as VoiceUser2x;
        
        if (user.intId == userId) {
          return user;
        }
      }				
      
      return null;
    }
    
    public function getIndex(userId: String):int {
      var user:VoiceUser2x;
      for (var i:int = 0; i < _users.length; i++) {
        user = _users.getItemAt(i) as VoiceUser2x;
        
        if (user.intId == userId) {
          return i;
        }
      }
      
      return -1;
    }
    
    private function startsWith(userId:String, voiceUserPrefix:String):Boolean {
      return userId.indexOf(voiceUserPrefix) == 0;
    }
    
    public function getVoiceOnlyUsers():Array {
      var temp: Array = new Array();
      for (var i:int = 0; i < _users.length; i++) {
        var user:VoiceUser2x = _users.getItemAt(i) as VoiceUser2x;
        
        // By convention, voice users starts with "v_"
        if (startsWith(user.intId, "v_")) {
          temp.push(user);
        }
      }
      return temp;
    }   
  }
}

