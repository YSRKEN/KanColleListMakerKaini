/**
 * json��������p�[�X���郂�W���[��
 */

#module jParseMod mssc

	/**
	 * json�������ǂݍ���
	 * @param json json������
	 */
	#modinit str json
		newcom mssc, "MSScriptControl.ScriptControl"
		mssc("Language") = "JScript"
		mssc -> "addCode" "obj = "+ json +";"
	return

	/**
	 * �L�[����l���󂯎��
	 * @param key �L�[
	 */
	#modcfunc local GetVal str key
		comres result
		mssc -> "Eval" "obj"+ key +" === null"
		if (result == -1) : return ""
		mssc -> "Eval" "obj"+ key
	return result

	/**
	 * �z��̗v�f�����擾����
	 * @param arrKey �z����w���L�[
	 */
	#modcfunc local GetLength str arrKey
		comres result
		mssc -> "Eval" "obj"+ arrKey +".length"
	return result

	#modterm
		delcom mssc
	return

#global
