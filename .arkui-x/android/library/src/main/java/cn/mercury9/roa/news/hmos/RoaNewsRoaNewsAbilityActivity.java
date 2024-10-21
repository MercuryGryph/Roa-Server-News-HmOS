package cn.mercury9.roa.news.hmos;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;


/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 * @see <a href=
 * "https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-integrate-arkui-into-android.md">
 * to build android library</a>
 */
public class RoaNewsRoaNewsAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "RoaNewsRoaNewsAbilityActivity");
        
        setInstanceName("cn.mercury9.roa.news.hmos:roaNews:RoaNewsAbility:");
        super.onCreate(savedInstanceState);
    }
}
