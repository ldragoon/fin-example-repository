#! /bin/bash

####
# This Section is run as an ADMINISTRATOR
####

# Create a shortcut for your inf4 command
inf4="${INF4} --session=dams-admin"

R=`echo $FEDORA_BASE | sed -e 's#^http[s]*://[^/]*##'`
# This adds your bearer token to the httpie --session=dams-admin, so you can now use inf4
http --session=dams-admin ${FEDORA_BASE} "Authorization:Bearer ${ADMIN_JWT}"
# Now cache that change for inf4
${inf4} --base=${FEDORA_BASE} GET
# OK, now we have a nice interface with an admin user.

# Add a default Access Control Location
acl=etc/acl
${inf4} mkdir $R/etc
${inf4} -d $R/etc/acl -- put -a webac:Acl <<< '<> rdfs:label "System Access Control" . '

# Add a new ACL that allows READ access to any user
${inf4} -d $R/etc/acl/Agent-r -- put -a acl:Authorization <<< "<> acl:agent foaf:Agent;
   acl:mode acl:Read ; acl:accessTo <$R> ."

# Use ACL in the root  $R 
${inf4} -d $R/ patch <<< '<> acl:accessControl <info:fedora/etc/acl> .'

# Now Let's make a /users area and add some users.  By default, each
# users area will only be writable by that user, but readable by
# everyone.  User's control their own access control

${inf4} mkdir $R/user

# This is for ACL
${inf4} mkdir $R/etc/agent

users="quinn jrmerz xiaolili Agent"

for u in ${users}; do
    my_dir=$R/user/$u
    my_acl=$R/user/$u/.acl
    sys_acl=$R/etc/acl

    ${inf4} mkdir $R/user/$u

    # Make a location for user information, owned by the users
    ${inf4} -d $sys_acl/${u}-w -- put -a acl:Authorization <<< "<> acl:agent \"${u}\"; acl:mode acl:Write, acl:Read; acl:accessTo <$R/user/$u>."
   
    # Make a user defined ACL
    ${inf4} -d $my_acl -- put -a webac:Acl <<<'<> rdfs:label "Local ACL".'

    # Now setup User  for writing
    if [[ $u == "Agent" ]]; then
	${inf4} -d $my_acl/$u-w -- put -a acl:Authorization <<< "<> acl:agent foaf:Agent; acl:mode acl:Write, acl:Read; acl:accessTo <$R/user/${u}> ."
    else
	${inf4} -d $my_acl/$u-w -- put -a acl:Authorization <<< "<> acl:agent \"${u}\"; acl:mode acl:Write, acl:Read; acl:accessTo <$R/user/${u}> ."
    fi
    # Setup a Agent reading by default
    ${inf4} -d $my_acl/Agent-r -- put -a acl:Authorization <<< "<> acl:agent foaf:Agent; acl:mode acl:Read; acl:accessTo <$R/user/${u}> ."

    # Patch to use these rules
    ${inf4} -d $my_dir patch <<< "<> acl:accessControl <info:fedora/user/$u/.acl>; dc:title \"$u Filestore\"."
    # Add in a picture
    ${inf4} -d $my_dir/picture -- put --mime-type=image/jpeg --sidecar=- user/$u/picture.jpg <<<"<> dc:title \"$u photo\" ."

done

# Now we will make some groups.  These will be for administration of
# the collections.  Everyone can see who's in the groups.

group=etc/group
${inf4} mkdir $R/$group
${inf4} -d $R/$group/eastman -- put -a foaf:Group <<< '<> foaf:member "quinn","jrmerz" . '
${inf4} -d $R/$group/eastman-example -- put -a foaf:Group <<< '<> foaf:member "quinn","jrmerz" . '
${inf4} -d $R/$group/catz -- put -a foaf:Group <<< '<> foaf:member "quinn","jrmerz","xiaoli" .'

# Now we will make some collections
${inf4} mkdir $R/collections

# Make the Each Collection
for u in Eastman eastman-example catz; do
    my_dir=$R/collections/$u
    my_acl=$my_dir/.acl;
    sys_acl=$R/$acl
    
    # Make the location
    ${inf4} mkdir $my_dir
    
    # The group can write my_dir
    ${inf4} -d $sys_acl/${u}-w -- put -a acl:Authorization <<< "<> acl:agentClass <$R/etc/group/$u> ; acl:mode acl:Write, acl:Read; acl:accessTo <$my_dir> ."

    # Make a group defined ACL
    ${inf4} -d $my_acl -- put -a webac:Acl <<<'<> rdfs:label "Local ACL".'

    # Now setup Group for writing
    ${inf4} -d $my_acl/$u-w -- put -a acl:Authorization <<< "<> acl:agentClass <$R/etc/group/$u>; acl:mode acl:Write, acl:Read; acl:accessTo <$my_dir> ."
    # Setup a Agent reading by default
    ${inf4} -d $my_acl/Agent-r -- put -a acl:Authorization <<< "<> acl:agent foaf:Agent; acl:mode acl:Read; acl:accessTo <$my_dir> ."
    # Finally access control for this container
    ${inf4} -d $my_dir patch <<< "<> acl:accessControl <info:fedora/collections/$u/.acl>;"
    ${inf4} -d $my_dir patch <<< "<> rdfs:label \" $u Collection\" ."
done

if (true); then
## Now let's read in all our collection data.
# This we want to do as user quinn.
inf4="${INF4} --session=dams"
# This adds your bearer token to the httpie so you can now use inf4
http --session=dams ${FEDORA_BASE} "Authorization:Bearer ${QUINN_JWT}"
# Now cache that change for inf4
${inf4} --base=${FEDORA_BASE} GET

for f in `find collections/eastman-example -type f -name \*.tif | grep -v '/fcr:metadata/'`; do
    d=`dirname $f`; b=`basename $f`;
    i=`basename $f .tif`;
#    i=`basename $f .* | sed -e 's/\.[^.]*$//'`;
    s=$d/fcr:metadata/$b;
    mime=`file --mime-type -b $f`;
    if [[ -f $s ]] ; then
	sidecar="--sidecar=$s"
    else
	sidecar=''
    fi
    ${inf4} -d $R/collections/eastman/$i -- put --mime-type=$mime $sidecar $f;
done
fi
